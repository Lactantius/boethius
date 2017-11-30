require_relative 'test_helper'
require 'boethius'

class RealBookTest < Minitest::Test

  include DemoProject
  include Boethius

  PREJUDICE = {
    id: 1003,
    name: "Pride and Prejudice",
    project_items: [
      {
        # selections: {
        #   section: [1,2,3,4,5],
        # },
        font: "Palatino",
        book: {
          title: "Pride and Prejudice",
          author: "Jane Austen",
          location: "pride_and_prejudice.xml",
          converter: "HTML_H2_TITLES",
          language: "English",
          pubdate: 1813,
        }
      }
    ]
  }

  def setup
    @tex = Tex.new(PREJUDICE)
    @tex_file = File.join(PROJECT_DIR, "#{@tex[:id]}.tex")
    # File.delete @tex_file if File.exist? @tex_file
    # File.delete @source if @source
    @pdf = File.join(PROJECT_DIR, "#{@tex[:id]}.pdf")
    File.delete @pdf if File.exist? @pdf
  end

  def test_accepts_data_for_pride_and_prejudice
    refute_nil @tex
  end

  def test_prejudice_source_file_generated
    @tex.generate
    @tex.compile
    assert File.exist? @pdf
  end

end
