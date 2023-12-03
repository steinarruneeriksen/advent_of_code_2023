module day03
using DataFrames
using Pandas


struct Field  
      id::String  
      num::Int  
      idx::Int
      adj::Bool

end
function identifier(x::Field)
      y = string(x.id) * "_" * string(x.idx)
      return y
end

import Base.isequal, Base.hash
function isequal(t1::Field, t2::Field)
  return identifier(t1) == identifier(t2)
end

function hash(t::Field)
  return hash( identifier(t))
end


function gear_with_surrounding_numbs(df, i,j)
      matched=Dict{Field, Field}()
      field=df[i,j]
      regex_num = r"[0-9]+"
      counter=0
      product=1
      for x = i-1:i+1
            for y= j-1:j+1
                  try
                        candidate=df[x,y]
                        if (match(regex_num,string(candidate.id))==nothing)==false
                              if haskey(matched, candidate)==false
                                    counter=counter+1 
                                    product=product * candidate.num
                                    matched[candidate]=candidate
                              end
                        end
                  catch
                  end

            end
      end

      if counter>1
            return product
      end
      return 0
end

function num_with_surrounding_char(df, i,j)
      field=df[i,j]
      regex_num = r"[0-9]+"
      found=false
      for x = i-1:i+1
            for y= j-1:j+1
                  try
                        candidate=df[x,y]
                        if candidate.id!="." && match(regex_num,string(candidate.id)) == nothing
                              found=true 
                        end
                  catch
                  end

            end
      end
      return found
end
function parse_file(file_name)
      allvec=[]
      idx=1
      pat = r"\d+?\d*|."
      found_nums=Dict{Field, Field}()
      found_all=Dict{Field, Field}()
      gear_value=0
      for line in readlines(file_name)
            vec=[]
            words = [ match.match for match in eachmatch(pat, line)]
            for m in words
                  if all(isdigit, m)
                        mx=parse(Int,m)
                        for i = 1:length(m)
                              push!(vec, Field(m, mx, idx, false ))  
                        end
                  else
                        push!(vec,Field(m, 0, idx, false ))       
                  end
                  idx=idx+1   # To make sure we do not exlude same number in different parts
            end
            push!(allvec, vec)

      end
      df = Pandas.DataFrame(allvec)
      totsum=0
      df1=DataFrames.DataFrame(df);
      regex_name = r"[0-9]+"
      for (i, row) in enumerate( eachrow( df1 ) ) 
            for (j, col) in enumerate(row)
                  candidate=df1[i,j]
                  if candidate.id=="*"
                        gear=gear_with_surrounding_numbs(df1, i,j)
                        if gear>1
                              println("Gear ",candidate, gear)
                              gear_value=gear_value+gear
                        end
                  end
                  if  match(regex_name,string(candidate.id)) == nothing
                        continue # Only eval numbers
                  end
                  if num_with_surrounding_char(df1, i,j)
                        if haskey(found_nums, candidate)==false
                              found_nums[candidate]=candidate
                        end
                  end
                  if haskey(found_all, candidate)==false
                        found_all[candidate]=candidate
                  end
            end
      end

      totsum=0
      for (key,val) in found_all
            if haskey(found_nums, key)
                  totsum=totsum+key.num
            end
      end
      println("Totsum ", totsum, " Gearval ",gear_value)
end

parse_file("./src/input.txt")

end