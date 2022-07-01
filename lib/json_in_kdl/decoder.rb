module JsonInKdl
  module Decoder
    class << self
      def decode(kdl)
        raise Error, "JiK must have exactly one root node" unless kdl.nodes.size == 1

        decode_node(kdl.nodes.first)
      end

      private

      def decode_node(node)
        case node.name
        when 'object'
          decode_object(node)
        when 'array'
          decode_array(node)
        when '-'
          decode_primitive(node)
        else
          raise Error, "JiK node names must be one of object, array, or '-'"
        end
      end

      def decode_object(node)
        raise "JiK object nodes should not have any arguments" unless node.arguments.empty?

        hash = {}
        node.properties.each do |key, value|
          hash[key] = value.value
        end
        node.children.each do |child|
          hash[child.type] = decode_node(child)
        end
        hash
      end

      def decode_array(node)
        raise "JiK array nodes should not have any properties" unless node.properties.empty?

        array = []
        node.arguments.each do |arg|
          array << arg.value
        end
        node.children.each do |child|
          array << decode_node(child)
        end
        array
      end

      def decode_primitive(node)
        raise "JiK primitive nodes should only have a single argument" unless node.arguments.size == 1
        raise "JiK primitive nodes should not have any properties" unless node.properties.empty?
        raise "JiK primitive nodes should not have any children" unless node.properties.empty?

        return node.arguments.first.value
      end
    end
  end
end