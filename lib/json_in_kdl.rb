# frozen_string_literal: true

require "kdl"
require "json"
require_relative "json_in_kdl/version"
require_relative "json_in_kdl/encoder"
require_relative "json_in_kdl/decoder"

module JsonInKdl
  class Error < StandardError; end

  class << self
    def encode(json)
      Encoder.encode(json)
    end

    def encode_string(string)
      Encoder.encode(JSON.parse(string))
    end

    def decode(kdl)
      Decoder.decode(kdl)
    end

    def decode_string(string)
      Decoder.decode(::KDL.parse_document(kdl))
    end
  end
end
