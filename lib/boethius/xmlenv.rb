require 'boethius/xml_converters'

module Boethius

  class Source < ::File

    def xmlenv tex
      tex[:project_items].each do |book|
        self.make_env_for book[:book]
      end
    end

    def make_env_for book

      # Defines the nodes that will be used in the XML file.
      # Example:
      # \startxmlsetups xml:foo
      #   \xmlsetsetup{#1}{*}{-}
      #   \xmlsetsetup{#1}{bob|bill|ted}{xml:*} (simple_xml)
      #   \xmlsetsetup{#1}{div/title}{xml:foosection} (title_nodes)
      # \stopxmlsetups
      lambda do |title, conv|
        self.puts "\\startxmlsetups xml:#{title}:*" # will break
        self.puts "  \\xmlsetsetup{\\xmldocument}{*}{-}"
        self.puts "  \\xmlsetsetup{\\xmldocument}" \
          "{#{simple_xml(conv)}}{xml:#{title}:*}"
        title_nodes(title, conv)
        self.puts "\\stopxmlsetups"
        self.puts ''
        self.puts "\\xmlregisterdocumentsetup{#{title}}" \
          "{xml:#{title}:*}"
        self.puts ''
      end.call(book[:title], book[:converter])

    end

    private

    def simple_xml(conv)
      nodes = []
      nodes << conv[:flush_nodes]
      nodes << conv[:par_nodes]
      nodes << sectioning_nodes(conv)
      nodes.join('|')
    end

    def title_nodes book_title, conv_hash
    # Goal: \xmlsetsetup{#1}{div/head}{xml:adventuresofbobsection}
      conv_hash[:sectioning_nodes].each_pair do |level, nodes|
        self.puts "  \\xmlsetsetup{\\xmldocument}{" \
          "#{nodes.keys.join}/#{nodes.values.join}}" \
          "{xml:#{book_title}:#{book_title}#{level}}"
      end
    end

    def sectioning_nodes conv
      conv[:sectioning_nodes].values.map { |section| section.keys }
    end

  end

end
