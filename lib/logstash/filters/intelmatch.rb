# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "redis"

# This example filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::IntelMatch < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   example {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "intelmatch"
  
  config :type, :validate => :string, :required => :true
  config :source, :validate => :string, :required => :true
  

  public
  def register
    # Add instance variables 
    @redis=Redis.new
  end # def register

  public
  def filter(event)

      # Replace the event message with our message as configured in the
      # config file.
      lupkey=@type+"-"+event[@source]
      lupval=@redis.lpop(lupkey)
      if lupval.nil?
        event["match_source"]=lupval
        event["match"] = lupkey
      else
        event["match_source"]=lupval
        event["match"]=lupkey
      end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Example
