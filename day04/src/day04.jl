module day04

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
            card, winners, mine=split(line, (':', '|'))
            tmp, card_id=split(card, "Card") 
            cards[parse(Int,card_id)]=Card(parse(Int,card_id), 0, 0)
            vec1=get_numbers(winners)
            vec2=get_numbers(mine)
            count=0
            totcount=totcount+1
            for v in vec2
                  if v in vec1
                        count=count+1
                  end
            end
            if count==0
                  res=0
            else
                  res = 2 ^ (count-1)
            end
            cards[parse(Int,card_id)].count=count      
            totres=totres+res
      end
      
      for i = 1:totcount 
            println("Managing ", i, " with count ",cards[i].count )   
            for j = (i + 1):(cards[i].count + i)
                  if j<=totcount
                        cards[j].copies=cards[j].copies + (cards[i].copies + 1)
                  end 
            end
      end
      allcards=0
      for i = 1:totcount 
            allcards=allcards + 1 + cards[i].copies  #Original plus copies
      end

      println("Totres ", totres," ", allcards)

end

parse_file("./src/input.txt")

end
