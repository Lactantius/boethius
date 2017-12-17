require_relative 'helpers'
require_relative 'titlepage'

module Boethius

  class Tex < Hash

    def filenames
      self[:project_items].each_with_object(String.new) do |item, file_list|
        book = item[:book]
        book_title = context_friendly book[:title]
        file_list << fill_title_page_of(book)
        file_list << "  \\starttitle[title={#{book[:title]}}]\n"
        # file_list << "    #{book[:author]}"
        file_list << "    \\xmlprocessfile{#{book_title}}" \
                     "{#{File.join(BOOK_DIR, book[:location])}}{}\n"
        file_list << reset_head_numbers(Boethius.const_get(book[:converter])[:sectioning_nodes],
                                        book_title)
        file_list << "  \\stoptitle\n\n"
      end
    end

    def reset_head_numbers(heads, book_title)
      String.new.tap do |reset_list|
        heads.each_key do |div|
          reset_list << "    \\setupheadnumber[#{book_title}#{div}][0]\n"
        end
      end
    end

#     def title_page_of book
#       <<-IN
# \\startstandardmakeup
# \\blank
# #{book[:title]}
# \\blank
# #{book[:author]}
# \\stopstandardmakeup
#       IN
#     end

  end
end
