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
        font: "Palatino",
        metadata: {
          title: "Biography of Bob",
          author: "Bobson",
          location: "biography_of_bob.xml",
          converter: BOBSON,
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
        font: "Palatino",
        book: {
          title: "Biography of Bob",
          author: "Bobson",
          location: "biography_of_bob.xml",
          converter: "BOBSON",
          language: "English",
          pubdate: 1813,
        }
      },
      { font: "Gentium",
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

end
