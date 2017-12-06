require_relative 'test_helper'
require 'boethius'

class SizeTest < Minitest::Test

  include DemoProject
  include Boethius

  LETTER_SIZE_BOOK = {
    id: "1201",
    name: "Letter Size Test",
    page_size: "letter",
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

  A4_SIZE_BOOK = {
    id: "1202",
    name: "A4 Size Test",
    page_size: "a4",
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

  def test_letter_size_book
    make_pdf_of LETTER_SIZE_BOOK
    assert @pdf.page_size? [612, 791.99999]
  end

  def test_a4_size_book
    make_pdf_of A4_SIZE_BOOK
    assert @pdf.page_size? [595.27559, 841.88976]
  end

end
