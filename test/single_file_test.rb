require_relative 'test_helper'
require 'boethius'

class BoethiusTest < Minitest::Test

  include DemoProject
  include Boethius

  def setup
    @tex = Tex.new(TESTDATA1)
    @tex_file = File.join(PROJECT_DIR, "#{@tex[:id]}.tex")
    # File.delete @tex_file if File.exist? @tex_file
    # File.delete @source if @source
    @pdf = File.join(PROJECT_DIR, "#{@tex[:id]}.pdf")
    # File.delete @pdf if File.exist? @pdf
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

  TESTDATA1_FILENAMES = <<~IN
    \s\s\\xmlprocessfile{BiographyofBob}{/home/keiser/boethius/books/biography_of_bob.xml}{}
    \s\s\\setupheadnumber[BiographyofBobsection][0]
  IN

  def test_filenames_function_returns_correct_filename_and_section_number_resets
    assert_equal @tex.filenames, TESTDATA1_FILENAMES
  end

  TESTDATA1_METADATA = <<~IN
    \\title{singlexmlfile}
  IN

  def test_metadata_function_returns_correct_formatting
    assert_equal @tex.metadata, TESTDATA1_METADATA
  end

  TESTDATA1_SELECTIONS = <<~IN
    \\startxmlsetups{xml:BiographyofBob:stuff}
    \s\s\\xmlfilter{#1}{/div[match()==1 or match()==4]/all()}
    \\stopxmlsetups

    \\startxmlsetups{xml:BiographyofBob:div}
    \\setupheadnumber[section][\\numexpr\\xmlmatch{#1}-1\\relax]
    \s\s\\xmlflush{#1}
    \\stopxmlsetups

  IN

  def test_select_sections_formats_properly_for_numbered_sections
    skip
    assert_equal(@tex.select_sections_from(TESTDATA1[:project_items].first),
                 TESTDATA1_SELECTIONS)
  end

  def test_testdata1_generates_expected_source_file
    @tex.generate
    assert File.exist? @tex_file
  end

  def test_testdata1_successfully_compiles_to_expected_location
    @tex.generate
    @tex.compile
    assert File.exist? @pdf
  end

end
