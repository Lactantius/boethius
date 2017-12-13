require_relative 'test_helper'
require 'boethius'

class FontTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_palatino_book
    palatino_book = setup_font('1101', 'Palatino Test', 'Palatino')
    make_pdf_of palatino_book
    assert @pdf.include_font? "TeXGyrePagella"
  end

  def test_gentium_book
    gentium_book = setup_font('1102', 'Gentium Test', 'Gentium')
    make_pdf_of gentium_book
    assert @pdf.include_font? "GentiumPlus"
  end

  def test_libertine_book
    skip
    libertine_book = setup_font('1103', 'Libertine Test', 'Libertine')
    make_pdf_of libertine_book
    assert @pdf.include_font? "Libertine"
  end

  # PALATINO_BOOK = {
  #   id: "1101",
  #   name: "Palatino Test",
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
