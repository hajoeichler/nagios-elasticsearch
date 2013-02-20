require 'spec_helper'

def silently(&block)
  original_verbosity = $VERBOSE
  $VERBOSE = nil
  yield
  $VERBOSE = original_verbosity
end

module CheckElasticsearch
  describe Command do
    describe "#check" do
      before(:each) do
        Excon.stubs.clear
        Excon.defaults = { :mock => true }
      end

      it "should just work" do
        silently { ARGV.clear; ARGV.concat %w{ check-elasticsearch --host example.com } }
        resp = {
          "status" => "green",
        }
        Excon.stub({:method => :get}, {:body => resp.to_json, :status => 200})

        c = Command.new
        STDOUT.should_receive(:puts).with("OK: green|health=0.0;;;;")
        lambda { c.run }.should raise_error SystemExit
      end

      it "should warn with yellow state" do
        silently { ARGV.clear; ARGV.concat %w{ check-elasticsearch --host example.com } }
        resp = {
          "status" => "yellow",
        }
        Excon.stub({:method => :get}, {:body => resp.to_json, :status => 200})

        c = Command.new
        STDOUT.should_receive(:puts).with("WARNING: yellow|health=1.0;;;;")
        lambda { c.run }.should raise_error SystemExit
      end

      it "should support #of data nodes" do
        silently { ARGV.clear; ARGV.concat %w{ check-elasticsearch --host example.com -A cluster_data_nodes -w @0:2 -c @0:1} }
        resp = {
          "number_of_data_nodes" => 2,
        }
        Excon.stub({:method => :get}, {:body => resp.to_json, :status => 200})

        c = Command.new
        STDOUT.should_receive(:puts).with("WARNING: 2|data_nodes=2.0;;;;")
        lambda { c.run }.should raise_error SystemExit
      end

      it "should support #of unassigned shards" do
        silently { ARGV.clear; ARGV.concat %w{ check-elasticsearch --host example.com -A cluster_unassigned_shards -w 1 -c 2} }
        resp = {
          "unassigned_shards" => 5
        }
        Excon.stub({:method => :get}, {:body => resp.to_json, :status => 200})

        c = Command.new
        STDOUT.should_receive(:puts).with("CRITICAL: 5|unassigned_shards=5.0;;;;")
        lambda { c.run }.should raise_error SystemExit
      end
    end
  end
end
