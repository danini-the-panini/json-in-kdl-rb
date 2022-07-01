# frozen_string_literal: true

require "kdl"
require "json"
require_relative "json_in_kdl/version"

module JsonInKdl
  class Error < StandardError; end

  class << self
    def json_to_kdl(json)
      return ::KDL::Document.new([json_to_node(json)])
    end

    private

    def json_to_node(json)
      case json
      when TrueClass, FalseClass, NilClass, Numeric, String
        primitive_to_node(json)
      when Hash
        object_to_node(json)
      when Array
        array_to_node(json)
      else
        raise Error, "#{json.inspect} is not a JSON type"
      end
    end

    def primitive_to_node(value)
      return ::KDL::Node.new('-', [::KDL::Value.from(value)])
    end

    def object_to_node(hash)
      props = {}
      children = []
      hash.each do |key, value|
        if children.any? || value.is_a?(Hash) || value.is_a?(Array)
          node = json_to_node(value)
          node.type = key
          children << node
        else
          props[key] = ::KDL::Value.from(value)
        end
      end
      return ::KDL::Node.new('object', [], props, children)
    end

    def array_to_node(array)
      attributes = []
      children = []
      array.each do |value|
        if children.any? || value.is_a?(Hash) || value.is_a?(Array)
          node = json_to_node(value)
          children << node
        else
          attributes << ::KDL::Value.from(value)
        end
      end
      return ::KDL::Node.new('array', attributes, {}, children)
    end
  end
end
