module day07

mutable struct Hand
      cards::String
      rank::Int
      copies::Int
end


function parse_file(file_name)
      cards=Dict{Int, Hand}()
      totres=0
      totcount=0
      card_rank=Array{Regex}(undef,0)
      push!(card_rank, r"^(A{5}|K{5}|Q{5}|J{5}|T|9|8|7|6|5|4|3|2{5})")
      push!(card_rank, r"^(A|K|Q|J|T|9|8|7|6|5|4|3|2){4,4}")
      push!(card_rank, r"^(A{3}|K{3}|Q{3}|J{3}|T{3}|9{3}|8{3}|7{3}|6{3}|5{3}|4{3}|3{3}|2{3})")
      push!(card_rank, r"^(A{2}|K{2}|Q{2}|J{2}|T{2}|9{2}|8{2}|7{2}|6{2}|5{2}|4{2}|3{2}|2{2})")

      #handreg=r"(5{3)"
      for line in readlines(file_name)
            h5, h3=split(line, " ")
            #println(h5)
            #h5=string(sort([a for a in h5]))
            #h5=ASCIIString(sort!(h5))
            h5=join(sort(collect(h5)))
            println(h5)
            for r in card_rank
                  if match(r, h5) != nothing
                        println("Found ",r, " " , h5)
                  end
            end

      end
 

end

parse_file("./src/sample.txt")

end
