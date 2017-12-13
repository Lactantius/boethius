require_relative 'test_helper'
require 'boethius'

class LayoutTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_makes_book_with_margin_data
    margin_data = { top: "2in", outer: ".2in", bottom: "1in", inner: "4in" }
    simple_margins = modify_base_data({ id: '1301', name: 'Simple Margins', margins: margin_data })
    make_pdf_of simple_margins
    assert File.exist? @pdf
  end

  # SIMPLE_MARGINS = {
  #   id: "1301",
  #   name: "Simple Margins",
  #   margins: { top: "2in", outer: ".2in", bottom: "1in", inner: "4in" },
  #   project_items: [
  #     {
  #       font: "Palatino",
  #       book: {
  #         title: "Biography of Bob",
  #         author: "Bobson",
  #         location: "biography_of_bob.xml",
  #         converter: "BOBSON",
  #         language: "English",
  #         pubdate: 1813,
  #       }
  #     }
  #   ]
  # }

end
