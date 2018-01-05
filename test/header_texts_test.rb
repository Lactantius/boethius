require_relative 'test_helper'
require 'boethius'

class HeaderTextsTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_makes_book_with_all_header_texts

    header_texts_data = { header_data: {
                            odd_left: "author",
                            odd_center: "page",
                            odd_right: "chapter",
                            even_left: "title",
                            even_center: "author",
                            even_right: "page"
                          }
                        }
    new_project_data = modify_base_data({ id: '1401', name: 'All Header Texts' })
    all_header_texts = modify_project_item_data(new_project_data,
                                                header_texts_data, 0)
    make_pdf_of all_header_texts
    assert File.exist? @pdf

  end

end
