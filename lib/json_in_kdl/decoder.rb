module JsonInKdl
  module Decoder
    class << self
      def decode(kdl)
        raise Error, "JiK must have exactly one root node" unless kdl.nodes.size == 1

        decode_node(kdl.nodes.first, true)
      end

      private

      def decode_node(node, top = false)
        case node.name
        when 'object'
          decode_object(node)
        when 'array'
          decode_array(node)
        when '-'
          decode_primitive(node, top)
        else
          raise Error, "JiK node names must be one of object, array, or '-'"
        end
      end

      def decode_object(node)
        raise Error, "JiK object nodes should not have any arguments" unless node.arguments.empty?

        hash = {}
        node.properties.each do |key, value|
          raise Error, "JiK object properties should not have a type" if value.type
          hash[key] = value.value
        end
        node.children.each do |child|
          raise Error, "JiK object children should have a type" unless child.type
          hash[child.type] = decode_node(child)
        end
        hash
      end

      def decode_array(node)
        raise Error, "JiK array nodes should not have any properties" unless node.properties.empty?

        array = []
        node.arguments.each do |arg|
          raise Error, "JiK array arguments should not have a type" if arg.type
          array << arg.value
        end
        node.children.each do |child|
          raise Error, "JiK array children should not have a type" if child.type
          array << decode_node(child)
        end
        array
      end

      def decode_primitive(node, top)
        raise Error, "JiK primitive nodes should only have a single argument" unless node.arguments.size == 1
        raise Error, "JiK primitive nodes should not have any properties" unless node.properties.empty?
        raise Error, "JiK primitive nodes should not have any children" unless node.children.empty?
        raise Error, "JiK primitive node argument should not have a type" if node.arguments.first.type
        raise Error, "JiK primitive nodes should not have a type" if top && node.type

        return node.arguments.first.value
      end
    end
  end
end