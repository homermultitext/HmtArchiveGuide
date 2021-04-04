using Dates

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end



function hfun_mostrecentpost()
   
    sorter(p) = begin
        ps  = splitext(p)[1]
        url = "/news/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end

    list = readdir("news")
    filter!(f -> endswith(f, ".md"), list)
    sort!(list, by=sorter, rev=true)
    ps  = splitext(list[1])[1]
    topurl = "/news/$ps/"
    topstripped = strip(topurl, '/')
    topdate = pagevar(topstripped, :published)
    toptitle = pagevar(topstripped, :title)
    formatteddate = Date(topdate, dateformat"d U Y")
    
    io = IOBuffer()
    write(io, """<span class='datelabel'>$topdate</span><a href="$topurl">$toptitle</a>""")
    return String(take!(io))
end

function hfun_blogposts()
  today = Dates.today()
  curyear = year(today)
  curmonth = month(today)
  curday = day(today)

  list = readdir("news")
  filter!(f -> endswith(f, ".md"), list)
  sorter(p) = begin
      ps  = splitext(p)[1]
      url = "/news/$ps/"
      surl = strip(url, '/')
      pubdate = pagevar(surl, :published)
      if isnothing(pubdate)
          return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
      end
      return Date(pubdate, dateformat"d U Y")
  end
  sort!(list, by=sorter, rev=true)

  io = IOBuffer()
  write(io, """<ul class="blog-posts">""")
  for (i, post) in enumerate(list)
      if post == "index.md"
          continue
      end
      ps  = splitext(post)[1]
      write(io, "<li><span class='datelabel'>")
      url = "/news/$ps/"
      surl = strip(url, '/')
      title = pagevar(surl, :title)
      pubdate = pagevar(surl, :published)
      if isnothing(pubdate)
          date    = "$curyear-$curmonth-$curday"
      else
          date    = Date(pubdate, dateformat"d U Y")
      end
      write(io, """$date</span><a href="$url">$title</a>""")
  end
  write(io, "</ul>")
  return String(take!(io))
end