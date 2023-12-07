module day06
using DataFrames


function parse_file(file_name)
      timelist=Array{Int}(undef,0)
      distlist=Array{Int}(undef,0)
      bigtime=0
      bigdist=0
      totres=0
      counter=0
      for line in readlines(file_name)
            counter+=1
            if counter==1
                  x, timestr=split(line, "Time:")
                  numbs=""
                  for t in eachmatch(r"\d+", timestr)
                        numbs=numbs*t.match
                        push!(timelist, parse(Int,t.match))
                  end
                  println(numbs)
                  bigtime=parse(Int,numbs)
            else
                  x, timestr=split(line, "Distance:")
                  numbs=""
                  for t in eachmatch(r"\d+", timestr)
                        numbs=numbs*t.match
                        push!(distlist, parse(Int,t.match))
                  end
                  println(numbs)
                  bigdist=parse(Int,numbs)
            end

    end
    println(timelist)
    println(distlist)
    totcount=1
    for j in 1:length(timelist)
      counter=0
      record=distlist[j]
      for press in 0:timelist[j]
            totsecs=timelist[j]
            dist=(totsecs-press)*press
            if dist>record
                  counter=counter+1
            end
      end
      totcount=totcount*counter
    end
    println("TOT ", totcount)

    counter=0
    for press in 0:bigtime
      totsecs=bigtime
      dist=(totsecs-press)*press
      if dist>bigdist
            counter=counter+1
      end
    end
    println("Bigrecord times ", counter)
end

parse_file("./src/input.txt")

end
