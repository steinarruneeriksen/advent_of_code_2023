module day02

function parse_file(file_name, bag_size)
      full_line=""
      game_def=""
      game_id_controlsum=0
      game_min_controlsum=0
      colors= Dict("blue" => 0, "green" => 0, "red" => 0)
      games=  Dict{Int, Int}()
      # Transliterated fortran main subroutine
      for line in readlines(file_name)
            columns = split(line, ":")
            if length(columns)==1
                  full_line=full_line *  line
                  continue # Search next
            end
            game_def=columns[1]
            tmp, game_id=split(game_def," ")
            full_line=full_line * columns[2]

            if in(games, game_id)
                  game=games[game_id]
            else
                  games[game_id]=Dict("id"=>game_id,"cubes"=>Dict("blue" => 0, "green" => 0, "red" => 0))
            end
            valid_game=true
            grabs=split(full_line, (';'))
            largest_val= Dict("blue" => 0, "green" => 0, "red" => 0)
            for g in grabs
                  games[game_id]["cubes"]=Dict("blue" => 0, "green" => 0, "red" => 0)
                  
                  for c in split(g, (','))
                        c=strip(c)
                        s, color=split(c, " ")
                        games[game_id]["cubes"][color]=games[game_id]["cubes"][color]+parse(Int,s)
                        if largest_val[color]<parse(Int,s)
                              largest_val[color]=parse(Int,s)
                        end
                  end

                  for c in ["blue", "red", "green"]
                        if games[game_id]["cubes"][c]>bag_size[c]
                              valid_game=false
                        end
                  end
            end
            tmp=1
            for c in ["blue", "red", "green"]
                  tmp=tmp*largest_val[c]
            end
            game_min_controlsum=game_min_controlsum+tmp
            if valid_game
                  game_id_controlsum=game_id_controlsum+parse(Int,game_id)
            end
            full_line=""
      end
      println("Control sum ", game_id_controlsum, " second part ", game_min_controlsum)
end

parse_file("./src/input.txt", Dict("blue" => 14, "green" => 13, "red" => 12))
end # module day02
