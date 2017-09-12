require 'boethius/xml_converters'

module Boethius

  class Source < ::File

    def xmlenv(tex)
      tex[:project_items].each do |book|
        self.make_env_for book[:metadata]
        self.select_sections_from book
      end
    end

    def make_env_for(book)

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
      book[:converter][:flush_nodes].each do |node|
        simple_flush(@title, node)
        add_space
      end

      # Puts in the sectioning nodes
      # Example:
      # \definehead[foosection][1]
      # \setuphead[foosection][number=yes]
      # The setuphead part of this will get much more complicated.
      lambda do |title, conv|
        conv[:sectioning_nodes].each_pair do |level, nodes|
          self.puts "\\definehead[#{title}#{level}][#{level}]"
          self.puts "\\setuphead[#{title}#{level}][number=yes]"
          add_space
        end
      end.call(@title, book[:converter])

      # Flushes title nodes
      # Example:
      # \startxmlsetups{xml:bob:head}
      #   \startsection[
      #                title={\xmlflush{#1}}
      #                ]
      #   \stopsection
      # \stopxmlsetups
      lambda do |title, conv|
        conv[:sectioning_nodes].each_pair do |level, nodes|
          self.puts "\\startxmlsetups{xml:#{title}:#{title}#{level}}"
          self.puts "  \\start#{title}#{level}["
          self.puts "    title={\\xmlflush{#1}}"
          self.puts "    ]"
          self.puts "  \\stop#{title}#{level}"
          self.puts "\\stopxmlsetups"
          add_space
        end
      end.call(@title, book[:converter])


      # Puts in standard paragraph nodes
      # Example:
      # \startxmlsetups{xml:foo:p}
      #   \xmlflush{#1}\endgraf
      # \stopxmlsetups
      book[:converter][:par_nodes].each do |node|
        simple_flush(@title, node, after_text: '\endgraf')
        add_space
      end

    end

    def select_sections_from book
      @title = context_friendly book[:metadata][:title]
      book[:metadata][:converter][:sectioning_nodes].each_pair do |level, node|
        div = node.keys.join
        if excerpts_specified_for? book, level
          self.puts "\\startxmlsetups{xml:#{@title}:#{node.values.first[:parent]}}"
          self.puts "  \\xmlfilter{#1}{/#{div}" \
                    "[match()==#{keep book, level}]/all()}"
          self.puts "\\stopxmlsetups"

          add_space

          set_head_numbers = "\\setupheadnumber[#{level}]" \
                             "[\\numexpr\\xmlmatch{#1}-1\\relax]\n  "
          simple_flush(@title, div, before_text: set_head_numbers)
        else
          simple_flush(@title, node.values.first[:parent])
          add_space
          simple_flush(@title, div)
        end
        add_space
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

    def simple_flush(book_title, node, before_text: nil, after_text: nil)
      self.puts "\\startxmlsetups{xml:#{book_title}:#{node}}"
      self.puts "  #{before_text}\\xmlflush{#1}#{after_text}"
      self.puts "\\stopxmlsetups"
    end

    def title_nodes(title, conv)
    # Goal: \xmlsetsetup{#1}{div/head}{xml:AdventuresofBobsection}
      conv[:sectioning_nodes].each_pair do |level, nodes|
        self.puts "  \\xmlsetsetup{\\xmldocument}{" \
          "#{nodes.keys.join}/#{nodes.values.first[:child]}}" \
          "{xml:#{title}:#{title}#{level}}"
      end
    end

    def sectioning_nodes(conv)
      conv[:sectioning_nodes].values.map { |section| section.keys }
    end

    def keep(book, section_level)
      book[:selections][:"#{section_level}"].join(' or match()==')
    end

    def excerpts_specified_for?(project_item, converter_section)
      project_item[:selections].keys.join.include? converter_section.to_s
    end

  end

end
