module Tacokit
  class << self
    def client
      @client ||= Tacokit::Client.new
    end

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end

require "tacokit/utils"
require "tacokit/resource"
require "tacokit/client"
require "tacokit/error"
require "tacokit/version"
