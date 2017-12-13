require_relative 'test_helper'
require 'boethius'

class SizeTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_letter_size_book
    letter_size_book = modify_base_data({ id: '1201', name: 'Letter Size Test',
                                          page_size: 'Letter' })
    make_pdf_of letter_size_book
    assert @pdf.page_size? [612, 791.99999]
  end

  def test_a4_size_book
    a4_size_book = modify_base_data({ id: '1202', name: 'A4 Size Test',
                                          page_size: 'A4' })
    make_pdf_of a4_size_book
    assert @pdf.page_size? [595.27559, 841.88976]
  end

end
