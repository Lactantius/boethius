require_relative 'helpers'

module Boethius

  class Tex < Hash

    def filenames
      self[:project_items].each_with_object(String.new) do |item, file_list|
        book = item[:book]
        book_title = context_friendly book[:title]
        file_list << "  \\xmlprocessfile{#{book_title}}" \
                     "{#{File.join(BOOK_DIR, book[:location])}}{}\n"
        file_list << reset_head_numbers(book[:converter][:sectioning_nodes],
                                        book_title)
      end
    end

    def reset_head_numbers(heads, book_title)
      String.new.tap do |reset_list|
        heads.each_key do |div|
          reset_list << "  \\setupheadnumber[#{book_title}#{div}][0]\n"
        end
      end
    end

  end
end
