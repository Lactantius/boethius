require_relative 'test_helper'
require 'boethius'

class TwoBookTest < Minitest::Test

  include DemoProject
  include Boethius

  def setup
    @tex = Tex.new(TESTDATA2)
    @tex_file = File.join(PROJECT_DIR, "#{@tex[:id]}.tex")
    # File.delete @tex_file if File.exist? @tex_file
    # File.delete @source if @source
    @pdf = File.join(PROJECT_DIR, "#{@tex[:id]}.pdf")
    # File.delete @pdf if File.exist? @pdf
  end

  def test_accepts_data_for_double_book
    refute_nil @tex
  end

  def test_makes_new_double_book_tex_file
    @source = @tex.generate
    assert File.exist?(DOUBLE_BOOK_BUILD_FILE)
    refute File.zero?(DOUBLE_BOOK_BUILD_FILE)
  end

  def test_double_book_build_file_has_the_book_metadata
    @source = @tex.generate
    assert @source.include? "twoxmlfile"
  end

  TESTDATA2_FILENAMES = <<~IN
    \s\s\\xmlprocessfile{BiographyofBob}{/home/keiser/boethius/books/biography_of_bob.xml}{}
    \s\s\\setupheadnumber[BiographyofBobsection][0]
    \s\s\\xmlprocessfile{MoreSimpleXML}{/home/keiser/boethius/books/more_simple_xml.xml}{}
    \s\s\\setupheadnumber[MoreSimpleXMLsection][0]
  IN

  def test_filenames_function_correct_for_two_books
    assert_equal @tex.filenames, TESTDATA2_FILENAMES
  end

  TESTDATA2_METADATA = <<~IN
    \\title{twoxmlfile}
  IN

  def test_metadata_function_correct_for_two_books
    assert_equal @tex.metadata, TESTDATA2_METADATA
  end

  TESTDATA2_SELECTIONS = <<~IN
    \\startxmlsetups{xml:BiographyofBob:stuff}
    \s\s\\xmlfilter{#1}{/div[match()==1 or match()==4]/all()}
    \\stopxmlsetups

    \\startxmlsetups{xml:BiographyofBob:div}
    \\setupheadnumber[section][\\numexpr\\xmlmatch{#1}-1\\relax]
    \s\s\\xmlflush{#1}
    \\stopxmlsetups

  IN

  def test_select_sections_works_for_two_books
    skip
    assert_equal(@tex.select_sections_from(TESTDATA2[:project_items].first),
                 TESTDATA2_SELECTIONS)
  end

  def test_testdata2_generates_expected_source_file
    @tex.generate
    assert File.exist? @tex_file
  end

  def test_testdata2_successfully_compiles_to_expected_location
    @tex.generate
    @tex.compile
    assert File.exist? @pdf
  end

end
