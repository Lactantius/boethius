module Boethius

  class Tex < Hash

    def title_page_setups
      <<-IN
\\definemakeup[titlepage][page]
\\setupmakeup[titlepage]
  [headerstate=empty,
   footerstate=empty]

      IN
    end

    def fill_title_page_of book
      <<-IN
\\starttitlepagemakeup
  \\vfill

  {\\itd{#{book[:title]}}}\\blank[3*big]

  {\\rmb{#{book[:author]}}}

  \\vfill
\\stoptitlepagemakeup 

      IN
    end

  end

end
