module day05
using DataFrames

mutable struct MapEntry
      destination::Int
      source::Int
      count::Int
end

mutable struct FieldMap
      map_data::Array{MapEntry}
      from_type::String
      to_type::String
end


function update_map(map::FieldMap, line::String)
      idxes = [ match.match for match in eachmatch(r"\d+", line)]
      entry=MapEntry(parse(Int,idxes[1]),parse(Int,idxes[2]),parse(Int,idxes[3]))
      push!( map.map_data, entry)

end


function find_location(seed, mapname, maps::Dict{String,FieldMap})
      map=maps[mapname]
      value=seed
      
      while true
            found=-1
            for elem in map.map_data
                  println("COMP ", elem.source," ",elem.count)
                  if value>= elem.source && value < (elem.source  + elem.count)
                        println("Found ",value," ", elem.destination, " ", elem.source)
                        found=value + elem.destination - elem.source
                        break
                  end
            end
            if found==-1
                  found=value  # If it was not in special rules, use same value
            end
            println("FOUND" , found)
            value=found
            mapname=map.to_type
            if mapname=="location"
                  return value   # This is the value of location
            end
            map=maps[mapname]
      end
end



function find_seed(location, mapname, maps::Dict{String,FieldMap})
      map=maps[mapname]
      value=location
      
      while true
            found=-1
            for elem in map.map_data
                  if value>= elem.source && value < (elem.source  + elem.count)
                        found=value + elem.destination - elem.source
                        break
                  end
            end
            if found==-1
                  found=value  # If it was not in special rules, use same value
            end
            value=found
            mapname=map.from_type
            if mapname=="seed"
                  return value   # This is the value of location
            end
            map=maps[mapname]
      end
end

function process_seedlist(seedlist::Array{Int}, maps::Dict{String,FieldMap})
      small=-1
      for i in  range(1,length(seedlist), step=2)
            for j in range(seedlist[i],seedlist[i] + seedlist[i+1] )

                 loc=find_location(j, "seed", maps::Dict{String,FieldMap})
                 if small==-1
                        small=loc
                 elseif loc<small
                        small=loc
                 end
            end
      end
      println("Smallest ", small)
      return small
end



function parse_file(file_name)
      allmaps=Dict{String,FieldMap}()
      seedlist=Array{Int}(undef,0)
      from_type=""
      to_type=""
      totres=0
      counter=0
      for line in readlines(file_name)
            counter+=1
            if counter==1
                  x, seedstr=split(line, "seeds:")
                  for seeds in eachmatch(r"\d+", seedstr)
                        push!(seedlist, parse(Int,seeds.match))
                  end
            else
                 if length(line)==0
                    continue
                 end
                 if match(r"\d+|' '", line) == nothing
                        mapname, final=split(line, " map:")
                        from_type, to_type=split(mapname, "-to-")
                        allmaps[from_type]=FieldMap(Array{MapEntry}(undef,0),from_type, to_type)
                 else
                        update_map(allmaps[from_type], line)
                 end
            end

    end
    #root=TreeNode("root", Array{TreeNode}(undef,0), 0, 0)
    #tree=construct_tree(root, "seed", allmaps)
    #println(tree)
    #sort_seeds(seedlist, allmaps)
    #return

    
    lowest=100000000000
    for seed in seedlist
      loc=find_location(seed, "seed", allmaps)
      if loc<lowest
            lowest=loc
      end
      println(" Seed ", seed, " with loc ", loc)
    end
    println("Lowest ", lowest)
    
end

parse_file("./src/sample.txt")

end
