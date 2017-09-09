require 'boethius/xml_converters'

module Boethius

  class Source < ::File

    def xmlenv tex
      tex[:project_items].each do |book|
        self.make_env_for book[:metadata]
        self.select_sections_from book
      end
    end

    def make_env_for book

      # Make the book title something usable by ConTeXt
      @title = context_friendly book[:title]

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
      end.call(@title, book[:converter])

      # Puts in the nodes that are simply flushed.
      # Example:
      # \startxmlsetups{xml:foo}
      #   \xmlflush{#1}
      # \stopxmlsetups
      lambda do |title, conv|
        conv[:flush_nodes].each do |node|
          self.puts "\\startxmlsetups{xml:#{title}:#{node}}"
          self.puts "  \\xmlflush{#1}"
          self.puts "\\stopxmlsetups"
          self.puts ''
        end
      end.call(@title, book[:converter])

      # Puts in the sectioning nodes
      # Example:
      # \definehead[foosection][1]
      # \setuphead[foosection][number=yes]
      # The setuphead part of this will get much more complicated.
      lambda do |title, conv|
        conv[:sectioning_nodes].each_pair do |level, nodes|
          self.puts "\\definehead[#{title}#{level}][#{level}]"
          self.puts "\\setuphead[#{title}#{level}][number=yes]"
        end
      end.call(@title, book[:converter])

      # Puts in standard paragraph nodes
      # Example:
      # \startxmlsetups{xml:foo:p}
      #   \xmlflush{#1}\endgraf
      # \stopxmlsetups
      lambda do |title, conv|
        conv[:par_nodes].each do |node|
          self.puts "\\startxmlsetups{xml:#{title}:#{node}}"
          self.puts "  \\xmlflush{#1}\\endgraf"
          self.puts "\\stopxmlsetups"
          self.puts ''
        end
      end.call(@title, book[:converter])

    end

    def select_sections_from book
      @title = context_friendly book[:metadata][:title]
      book[:metadata][:converter][:sectioning_nodes].each_pair do |level, node|
        if book[:selections].keys.join.include? level.to_s
          self.puts "\\startxmlsetups{xml:#{@title}:#{node.values.first[:parent]}}"
          self.puts "  \\xmlfilter{#1}{/#{node.keys.join}" \
                    "[match()==#{keep book, level}]/all()}"
          self.puts "\\stopxmlsetups"
          self.puts ''
          self.puts "\\startxmlsetups{xml:#{@title}:#{node.keys.join}}"
          self.puts "  \\setupheadnumber[#{level}]" \
                    "[\\numexpr\\xmlmatch{#1}-1\\relax]"
          self.puts "  \\xmlflush{#1}"
          self.puts "\\stopxmlsetups"
        else
          self.puts "\\startxmlsetups{xml:#{@title}:#{node.values.first[:parent]}}"
          self.puts "  \\xmlflush{#1}"
          self.puts "\\stopxmlsetups"
          self.puts ''
          self.puts "\\startxmlsetups{xml:#{@title}:#{node.keys.join}}"
          self.puts "  \\xmlflush{#1}"
          self.puts "\\stopxmlsetups"
        end
      end
    end

    private

    def simple_xml(conv)
      nodes = []
      nodes << conv[:flush_nodes]
      nodes << conv[:par_nodes]
      nodes << sectioning_nodes(conv)
      nodes.join('|')
    end

    def title_nodes title, conv
    # Goal: \xmlsetsetup{#1}{div/head}{xml:adventuresofbobsection}
      conv[:sectioning_nodes].each_pair do |level, nodes|
        self.puts "  \\xmlsetsetup{\\xmldocument}{" \
          "#{nodes.keys.join}/#{nodes.values.first[:child]}}" \
          "{xml:#{title}:#{title}#{level}}"
      end
    end

    def sectioning_nodes conv
      conv[:sectioning_nodes].values.map { |section| section.keys }
    end

    def context_friendly title
      # This will need much more work
      title.delete(' ')
    end

    def keep book, section_level
      book[:selections][:"#{section_level}"].join(' or match()==')
    end

  end

end
