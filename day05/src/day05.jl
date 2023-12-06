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

mutable struct Pair
      from_value::Int
      until_value::Int
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
                  if value>= elem.source && value < (elem.source  + elem.count)
                        println("Found ",value," ", elem.destination, " ", elem.source)
                        found=value + elem.destination - elem.source
                        break
                  end
            end
            if found==-1
                  found=value  # If it was not in special rules, use same value
            end
            value=found
            mapname=map.to_type
            if mapname=="location"
                  return value   # This is the value of location
            end
            map=maps[mapname]
      end
end


function find_location_pair(seed, mapname, maps::Dict{String,FieldMap})
      map=maps[mapname]
      value=seed
      println(value)
      while true
            found=nothing
            #for p in value.from_value:value.until_value
            for elem in map.map_data
                  if value.from_value>= elem.source && value.from_value < (elem.source  + elem.count) 
                        tmp=value.from_value + elem.destination - elem.source
                        println("Got tmp ", tmp)
                        if value.until_value>= elem.source && value.until_value < (elem.source  + elem.count) 
                              tmp2=value.until_value + elem.destination - elem.source
                              println("Got tm2p ", tmp2)
                        else
                              tmp2=(elem.destination  + elem.count) 
                              println("Got tmp2 ", tmp2)
                        end
                        found=Pair(tmp, tmp2)
                        break
                  end
            end
                  #found=Pair(tmp, tmp2)
            #end
            if found==nothing
                  found=value  # If it was not in special rules, use same value
            end
            value=found
            mapname=map.to_type
            if mapname=="location"

                  println("VAL ", value)
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
                  if value>= elem.destination && value < (elem.destination  + elem.count)
                        found=value + elem.source - elem.destination
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

function pairwise_seedlist(seedlist::Array{Int})
      seedpairlist=Array{Pair}(undef,0)
      for i in  range(1,length(seedlist), step=2)
            push!(seedpairlist, Pair(seedlist[i],(seedlist[i] + seedlist[i+1])))

      end
      println("Smallest ", seedpairlist)
      return seedpairlist
end

function location_list(mapping::Dict{String,FieldMap})
      nmap=Dict{String,FieldMap}()
      for (key, val) in mapping
            nmap[val.to_type]=val  
      end
      return nmap
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
    ps=pairwise_seedlist(seedlist)
    
    newmaps=location_list(allmaps)
    map=newmaps["location"]
    loclist=Array{Int}(undef,0)
    first=true
    for elem in map.map_data
      if first
            for i = 1:elem.destination
                  #push!(loclist,i)
                  sd=find_seed(i, "location", newmaps)
                  for p in ps
                        if sd>=p.from_value && sd<p.until_value
                              println("-----")
                              println("Found it ", p, " -> ", i)
                              return
                        end
                  end
            end
            first=false
      end
      for i = elem.destination:elem.source
            #push!(loclist,i)
            sd=find_seed(i, "location", newmaps)
            for p in ps
                  if sd>=p.from_value && sd<p.until_value
                        println("-----")
                        println("Found it ", p, " -> ", i)
                        return
                  end
            end
      end
    end
    return
    loclist=sort(loclist)
    println(loclist)
    #return
    #println(loclist)

    for id in loclist
      sd=find_seed(id, "location", newmaps)
      #println(sd, " =Z> ", id)
      for p in ps
            if sd>=p.from_value && sd<p.until_value
                  println("-----")
                  println("Found it ", p, " -> ", id)
                  return
            end
      end
   
    end
    return
    for id in map.map_data
      println(id)
    end
    return 
    pairlist=pairwise_seedlist(seedlist)
   
    lowest=nothing
    for seed in pairlist
      loc=find_location_pair(seed, "seed", allmaps)
      if lowest == nothing
            lowest=loc
      elseif lowest.from_value <loc.from_value
            lowest=loc
      end
      println(" Seed ", seed, " with loc ", loc)
    end
    println("Lowest ", lowest)
    
end

parse_file("./src/input.txt")

end
