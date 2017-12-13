$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "boethius"
require "minitest/autorun"
require "pdf/inspector"

include Boethius

module DemoProject

  TESTDATA1 = {
    id: "1001",
    name: "singlexmlfile",
    project_items: [
      {
        selections: {
          section: [1,4],
        },
        font: "Libertine",
        book: {
          title: "Biography of Bob",
          author: "Bobson",
          location: "biography_of_bob.xml",
          converter: "BOBSON",
          language: "English",
          pubdate: 1813,
        }
      }
    ]
  }

  TESTDATA2 = {
    id: "1002",
    name: "twoxmlfile",
    project_items: [
      {
        # selections: {
        #   section: [1,4],
        # },
        font: "Palatino",
        book: {
          title: "Biography of Bob",
          author: "Bobson",
          location: "biography_of_bob.xml",
          converter: "BOBSON",
          language: "English",
          pubdate: 1813,
        }
      }, {
        # selections: {
        #   section: [1,2,4],
        # },
        font: "Gentium",
        book: {
          title: "More Simple XML",
          author: "Bob III",
          location: "more_simple_xml.xml",
          converter: "BOBSON",
          language: "Latin",
          pubdate: 2500,
        }
      }
    ]
  }

  SINGLE_BOOK_BUILD_FILE = "projects/#{TESTDATA1[:id]}.tex"
  SINGLE_BOOK_FINAL_PDF = "projects/#{TESTDATA1[:id]}.pdf"

  DOUBLE_BOOK_BUILD_FILE = "projects/#{TESTDATA2[:id]}.tex"
  DOUBLE_BOOK_FINAL_PDF = "projects/#{TESTDATA2[:id]}.pdf"

  def make_pdf_of book
    @tex = Tex.new(book)
    @tex_file = File.join(PROJECT_DIR, "#{@tex[:id]}.tex")
    @pdf = Pathname.new(File.join(PROJECT_DIR, "#{@tex[:id]}.pdf"))
    File.delete @pdf if File.exist? @pdf
    @tex.generate
    @tex.compile
  end

  def setup_font(id, name, font)
    data_diff = { id: id, name: name }
    book_settings = Hash[DemoProject::TESTDATA1].merge(data_diff)
    book_settings[:project_items].first[:font] = font
    return book_settings
  end

  class Pathname < ::Pathname

    def include_font? name
      text = PDF::Inspector::Text.analyze(File.open(self, 'r'))
      text.font_settings.any? { |setting| setting[:name].to_s.include? name }
    end

    def page_size? dimensions
      file = PDF::Inspector::Page.analyze(File.open(self, 'r'))
      file.pages.first[:size] == dimensions
    end

  end

end
