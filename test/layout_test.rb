require_relative 'test_helper'
require 'boethius'

class LayoutTest < Minitest::Test

  include DemoProject
  include Boethius

  SIMPLE_MARGINS = {
    id: "1301",
    name: "Simple Margins",
    margins: { top: "2in", outer: ".2in", bottom: "1in", inner: "4in" },
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

  def test_makes_book_with_margin_data
    make_pdf_of SIMPLE_MARGINS
    assert File.exist? @pdf
  end

end
