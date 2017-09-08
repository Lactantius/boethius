require_relative 'test_helper'
require 'boethius'

class BoethiusTest < Minitest::Test

  include DemoProject
  include Boethius

  def setup
    @tex = Tex.new(TESTDATA1)
    File.delete @source if @source
  end

  def test_that_it_has_a_version_number
    refute_nil ::Boethius::VERSION
  end

  def test_accepts_data_for_single_book
    refute_nil @tex
  end

  def test_makes_new_single_book_tex_file
    @source = @tex.generate
    assert File.exist?(SINGLE_BOOK_BUILD_FILE)
    refute File.zero?(SINGLE_BOOK_BUILD_FILE)
  end

  def test_single_book_build_file_has_the_book_metadata
    @source = @tex.generate
    assert @source.include? "singlexmlfile"
  end

  def test_single_book_build_file_has_book_title
    @source = @tex.generate
    assert @source.include? TESTDATA1[:project_items].first[:book][:title]
  end

end
