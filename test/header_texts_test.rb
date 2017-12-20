require_relative 'test_helper'
require 'boethius'

class HeaderTextsTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_makes_book_with_all_header_texts
    header_texts_data = { odd_left: "author", odd_middle: "page",
                          odd_right: "chapter", even_left: "title",
                          even_middle: "author", even_right: "page" }
    all_header_texts = modify_base_data({ id: '1401', name: 'All Header Texts',
                                          header_texts: header_texts_data })
    make_pdf_of all_header_texts
    assert File.exist? @pdf
  end

end
