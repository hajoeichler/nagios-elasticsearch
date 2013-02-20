class CheckElasticsearch::Command
  include NagiosCheck

  on "--host HOST", "-H HOST", :mandatory
  on "--port PORT", "-P PORT", :default => 9200
  on "--action ACTION", "-A ACTION", :default => "cluster_health"
  on "--debug", :default => false

  enable_warning
  enable_critical
  enable_timeout

  def initialize
    super()
    @params = {
      "cluster_health" => { "url" => "_cluster/health" },
      "cluster_data_nodes" => {
        "url" => "_cluster/health",
        "element" => "number_of_data_nodes",
        "name" => "data_nodes"
      },
      "cluster_unassigned_shards" => {
        "url" =>"_cluster/health",
        "element" => "unassigned_shards",
        "name" => "unassigned_shards"
      }
    }
  end

  def debug(msg)
    warn msg if options.debug
  end

  # Thank you! See https://github.com/phrawzty/check_http_json
  def hash_flatten(hash, delimiter, prefix = nil, flat = {})
    if hash.is_a? Array then
        hash.each_index do |index|
            newkey = index
            newkey = nil if hash.length == 1
            newkey = prefix if prefix
            val = hash[index]
            hash_flatten val, delimiter, newkey, flat
        end
    elsif hash.is_a? Hash then
        hash.keys.each do |key|
            newkey = key
            newkey = '%s%s%s' % [prefix, delimiter, key] if prefix
            val = hash[key]
            hash_flatten val, delimiter, newkey, flat
        end
    else
        flat[prefix] = hash
    end
    return flat
  end

  def fetch
    url = "http://#{options.host}:#{options.port}/#{@params[options.action]["url"]}"
    resp = Excon.get(url,
                     :headers => { "Accept" => "application/json" },
                     :expects => [200])
    JSON.parse(resp.body)
  end

  def cluster_health(data)
      options.w = NagiosCheck::Range.new("0.99")
      options.c = NagiosCheck::Range.new("1.99")
      case data["status"]
      when "green";  store_value(:health, 0)
      when "yellow"; store_value(:health, 1)
      when "red";    store_value(:health, 2)
      else;          store_value(:health, 3)
      end
      store_message(data["status"])
  end

  def check_path(data)
    name = @params[options.action]["name"]
    element = @params[options.action]["element"]
    store_value(name, data[element].to_i)
    store_message("#{data[element]}")
  end

  def check
    data = fetch
    case options.action
    when /cluster_health/; cluster_health(data)
    when /cluster_data_nodes/; check_path(data)
    when /cluster_unassigned_shards/; check_path(data)
    else; raise "Not implemented yet"
    end
  end
end
