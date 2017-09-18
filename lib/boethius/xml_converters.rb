module Boethius

  # Just for simple tests
  BOBSON = {
    flush_nodes: ['stuff'],
    sectioning_nodes: {
      section: {
        div: {
          parent: 'stuff',
          child:  'head',
        },
      },
    },
    par_nodes: ['p'],
  }

  HTML_H2_TITLES = {
    flush_nodes: ['html', 'body'],
    sectioning_nodes: {
      section: {
        div: {
          parent: 'body',
          child: 'h2',
        },
      },
    },
    par_nodes: ['p'],
    it_nodes: ['i'],
  }

end
