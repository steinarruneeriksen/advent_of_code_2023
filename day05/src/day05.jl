module day05

mutable struct Card
      id::Int
      count::Int
      copies::Int
end

import Base.isequal, Base.hash
function isequal(t1::Card, t2::Card)
  return t1.id == t2.id
end

function hash(t::Card)
  return hash( t.id)
end

function get_numbers(str)
      vec=Array{Int}(undef,0)
      for num in split(str, (' '))
            if num==""
                  continue
            end
            push!(vec, parse(Int,num))
      end
      return vec
end

function parse_file(file_name)
    cards=Dict{Int, Card}()
    totres=0
    totcount=0
    for line in readlines(file_name)
        #card, winners, mine=split(line, (':', '|'))
        println(line)

    end

end

parse_file("./src/sample.txt")

end
