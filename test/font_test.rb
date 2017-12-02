require_relative 'test_helper'
require 'boethius'

class FontTest < Minitest::Test

  include DemoProject
  include Boethius

  # This way seems pretty lame.
  PALATINO_BOOK = {
    id: "1101",
    name: "Palatino Test",
    project_items: [
      {
        font: "Palatino",
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

  GENTIUM_BOOK = {
    id: "1102",
    name: "Gentium Test",
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
    id: "1103",
    name: "Libertine Test",
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

  def test_palatino_book
    make_pdf_of PALATINO_BOOK
    assert @pdf.include_font? "TeXGyrePagella"
  end

  def test_gentium_book
    make_pdf_of GENTIUM_BOOK
    assert @pdf.include_font? "GentiumPlus"
  end

  def test_libertine_book
    make_pdf_of LIBERTINE_BOOK
    assert @pdf.include_font? "Libertine"
  end

end
