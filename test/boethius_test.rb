require_relative 'test_helper'
require 'boethius'

class BoethiusTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_that_it_has_a_version_number
    refute_nil ::Boethius::VERSION
  end

  def test_accepts_data_for_single_book
    initialize_new_project_from TESTDATA1
  end

end
