# frozen_string_literal: true

require "test_helper"

class TestConvert < Minitest::Test
  JSON_DIR = File.join(__dir__, 'json')
  KDL_DIR = File.join(__dir__, 'kdl')

  Dir.glob(File.join(JSON_DIR, '*.json')).each do |json_path|
    input_name = File.basename(json_path, '.json')
    kdl_path = File.join(KDL_DIR, "#{input_name}.kdl")
    define_method "test_#{input_name}_matches_expected_output" do
      json = ::JSON.parse(File.read(json_path))
      kdl = ::KDL.parse_document(File.read(kdl_path))
      assert_equal kdl, JsonInKdl.json_to_kdl(json)
    end
  end
end
