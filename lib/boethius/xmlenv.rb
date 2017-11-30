require 'boethius/xml_converters'
require 'boethius/helpers'

module Boethius

  class Tex < Hash

    def xmlenv
      self[:project_items].each_with_object(String.new) do |item, xml|
        xml << make_env_for(item[:book])
        xml << select_sections_from(item)
      end
    end

    def make_env_for(book)

      # Make the book title something usable by ConTeXt
      @title = context_friendly book[:title]
      @conv  = Boethius.const_get(book[:converter])

      # Defines the nodes that will be used in the XML file.
      # Example:
      # \startxmlsetups xml:foo
      #   \xmlsetsetup{#1}{*}{-}
      #   \xmlsetsetup{#1}{bob|bill|ted}{xml:*} (simple_xml)
      #   \xmlsetsetup{#1}{div/title}{xml:foosection} (title_nodes)
      # \stopxmlsetups
      nodes_setup = <<~IN
        \\startxmlsetups xml:#{@title}:*
        \s\s\\xmlsetsetup{\\xmldocument}{*}{-}
        \s\s\\xmlsetsetup{\\xmldocument}{#{simple_xml(@conv)}}{xml:#{@title}:*}
        #{title_nodes(@title, @conv)}
        \\stopxmlsetups

        \\xmlregisterdocumentsetup{#{@title}}{xml:#{@title}:*}

      IN

      # Puts in the nodes that are simply flushed.
      # Example:
      # \startxmlsetups{xml:foo}
      #   \xmlflush{#1}
      # \stopxmlsetups
      flushed = @conv[:flush_nodes].map { |node| simple_flush(@title, node) }

      # Puts in the sectioning nodes
      # Example:
      # \definehead[foosection][1]
      # \setuphead[foosection][number=yes]
      # The setuphead part of this will get much more complicated.
      section_nodes = String.new.tap do |sections|
        @conv[:sectioning_nodes].each_pair do |level, nodes|
          sections << <<~IN
            \\definehead[#{@title}#{level}][#{level}]
            \\setuphead[#{@title}#{level}][number=yes]

          IN
        end
      end

      # Flushes title nodes
      # Example:
      # \startxmlsetups{xml:bob:head}
      #   \startsection[
      #                title={\xmlflush{#1}}
      #                ]
      #   \stopsection
      # \stopxmlsetups
      title_setups = String.new.tap do |titles|
        @conv[:sectioning_nodes].each_pair do |level, _|
          titles << <<~IN
            \\startxmlsetups{xml:#{@title}:#{@title}#{level}}
            \s\s\\start#{@title}#{level}[
            \s\s\s\stitle={\\xmlflush{#1}}
            \s\s\s\s]
            \s\s\\stop#{@title}#{level}
            \\stopxmlsetups

          IN
        end
      end

      # Puts in standard paragraph nodes
      # Example:
      # \startxmlsetups{xml:foo:p}
      #   \xmlflush{#1}\endgraf
      # \stopxmlsetups
      par_nodes = @conv[:par_nodes].map do |node|
        simple_flush(@title, node, before_text: '  ', after_text: '\endgraf')
      end

      # Puts in italic nodes
      # Example:
      # \startxmlsetups{xml:foo:i}
      #   {\em\xmlflush{#1}}
      # \stopxmlsetups
      if @conv[:it_nodes]
        it_nodes = @conv[:it_nodes].map do |node|
          simple_flush(@title, node, before_text: '  {\em', after_text: '}')
        end
      end

      [nodes_setup, flushed, section_nodes, title_setups, par_nodes, it_nodes].join

    end

    def select_sections_from book
      @title = context_friendly book[:book][:title]
      String.new.tap do |excerpts|
        # book[:book][:converter][:sectioning_nodes].each_pair do |level, node|
        @conv[:sectioning_nodes].each_pair do |level, node|
          div = node.keys.join
          parent_node = node.values.first[:parent]
          # For anthologizing.
          # if excerpts_specified_for?(book, level)
          #   excerpts << <<~IN
          #     \\startxmlsetups{xml:#{@title}:#{parent_node}}
          #     \s\s\\xmlfilter{#1}{/#{div}[match()==#{keep book, level}]/all()}
          #     \\stopxmlsetups

          #   IN

          #   set_head_numbers = "\\setupheadnumber[#{level}]" \
          #                      "[\\numexpr\\xmlmatch{#1}-1\\relax]\n  "
          #   excerpts << simple_flush(@title, div, before_text: set_head_numbers)
          # else
          excerpts << simple_flush(@title, parent_node)
          excerpts << simple_flush(@title, div)
          # end
        end
      end
    end

    private

    def simple_xml(conv)
      nodes = [sectioning_nodes(conv), conv[:flush_nodes], conv[:par_nodes], conv[:it_nodes]]
      nodes.join('|')
    end

    def simple_flush(book_title, node, before_text: nil, after_text: nil)
      <<~IN
        \\startxmlsetups{xml:#{book_title}:#{node}}
        #{before_text}\\xmlflush{#1}#{after_text}
        \\stopxmlsetups

      IN
    end

    def title_nodes(title, conv)
    # Goal: \xmlsetsetup{#1}{div/head}{xml:AdventuresofBobsection}
      String.new.tap do |title_node|
        conv[:sectioning_nodes].each_pair do |level, nodes|
          title_node << "  \\xmlsetsetup{\\xmldocument}{" \
                        "#{nodes.keys.join}/#{nodes.values.first[:child]}}" \
                        "{xml:#{title}:#{title}#{level}}"
        end
      end
    end

    def sectioning_nodes(conv)
      conv[:sectioning_nodes].values.map { |section| section.keys }
    end

    def keep(book, section_level)
      book[:selections][:"#{section_level}"].join(' or match()==')
    end

    # Maybe do something with this later.
    # def excerpts_specified_for?(project_item, converter_section)
    #   project_item[:selections].keys.join.include? converter_section.to_s
    # end

  end

end
