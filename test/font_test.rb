require_relative 'test_helper'
require 'boethius'

class FontTest < Minitest::Test

  include DemoProject
  include Boethius

  testdata = DemoProject::TESTDATA1

  # How can I do this all at once?
  palatino = testdata
  palatino[:id] = 1101
  palatino[:project_items].first[:font] = "Palatino"
  PALATINO_BOOK = palatino

  GENTIUM_BOOK = {
    id: "1101",
    name: "Palatino Test",
    project_items: [
      {
        font: "Gentium",
        book: {
          title: "Biography of Bob",
          author: "Bobson",
          location: "biography_of_bob.xml",
          converter: "BOBSON",
          language: "English",
          pubdate: 1813,
        }
      }
    ]
  }

  LIBERTINE_BOOK = {
    id: "1101",
    name: "Palatino Test",
    project_items: [
      {
        font: "Libertine",
        book: {
          title: "Biography of Bob",
          author: "Bobson",
          location: "biography_of_bob.xml",
          converter: "BOBSON",
          language: "English",
          pubdate: 1813,
        }
      }
    ]
  }

  def setup
    @tex = Tex.new(PALATINO_BOOK)
    @tex_file = File.join(PROJECT_DIR, "#{@tex[:id]}.tex")
    @pdf = File.join(PROJECT_DIR, "#{@tex[:id]}.pdf")
    File.delete @pdf if File.exist? @pdf
  end

  def test_palatino_book
    @tex.generate
    @tex.compile
    text = PDF::Inspector::Text.analyze(File.open(@pdf, 'r'))
    assert text.font_settings.any? { |setting| setting[:name].to_s.include? "TeXGyrePagella" }
  end

end
