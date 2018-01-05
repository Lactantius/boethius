require_relative 'test_helper'
require 'boethius'

class PageNumberingTest < Minitest::Test

  include DemoProject
  include Boethius

  def test_makes_book_with_bottom_page_number

    number_settings = { page_numbering: { vertical: 'footer',
                                          horizontal: 'middle' } }
    new_project_data = modify_base_data({ id: '1501',
                                          name: 'Number Bottom Middle' })

    middle_bottom_numbering = modify_project_item_data(new_project_data,
                                                       number_settings, 0)

    make_pdf_of middle_bottom_numbering
    assert File.exist? @pdf

  end

end
