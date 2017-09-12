require_relative 'helpers'

module Boethius

  class Source < ::File

    def filenames tex
      tex[:project_items].each do |book|
        file_data = book[:metadata]
        title = context_friendly file_data[:title]
        self.puts "  \\xmlprocessfile{#{title}}{#{file_data[:location]}}{}"
        file_data[:converter][:sectioning_nodes].each_key do |div|
          self.puts "  \\setupheadnumber[#{title}#{div}][0]"
        end
      end
    end

  end
end
