use std::fs::File;
use std::io::BufReader;
use std::collections::HashMap;
use std::io::prelude::*;
use std::fmt;
enum CubeColour {
    blue,
    red,
    green
}

impl CubeColour {
    fn as_str(&self) -> &'static str {
        match self {
            CubeColour::blue => "blue",
            CubeColour::red => "red",
            CubeColour::green => "green"
        }
    }
}

fn color_from_str(color:String)-> CubeColour  {
    let b=match color.as_str() {
        "blue" => CubeColour::blue,
        "red" => CubeColour::red,
        "green" => CubeColour::green,
        _ => CubeColour::green
    };
    b
}


struct Cube {
    color: CubeColour,
    count: i32,
}
impl Cube {
    fn increment(&mut self, v:i32) {
        self.count=self.count+ v;
    }
}
pub struct Game {
    pub game_id: String,
    pub valid: bool,
    pub  cubes :HashMap<String, Cube>
}

fn parse_input(filepath: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mut games:HashMap<String, crate::Game > = HashMap::new();
    let file = File::open(filepath)?;
    let reader = BufReader::new(file);
    let mut grandsum: i64 = 0;
    for line in reader.lines() {
        let safe_line=line?;
        let v1: Vec<String> = safe_line.split(":").map(|s| s.to_string()).collect();
        let game_def:String = v1.clone().into_iter().nth(0).unwrap();
        let game_play:String = v1.clone().into_iter().nth(1).unwrap();
        let gamestr: Vec<String>=game_def.split(" ").map(|s| s.to_string()).collect();
        let cubes: Vec<String>=game_play.split(",").map(|s| s.to_string()).collect();

        println!("Game {}  ",gamestr[1].to_string());
        let mut game:Game=Game{ game_id: gamestr[1].to_string(), valid: false, cubes:HashMap::new()};

        println!("Collecting for game {:?}  ",game.game_id);
        for  cube in cubes{
            let c=cube.trim();
            let count_col: Vec<String>=c.split(" ").map(|s| s.to_string()).collect();
            let counter = count_col[0].to_string();
            let n=counter.parse::<i32>();
            let col=color_from_str(count_col[1].to_string());
            println!("Cube {:?} {}  ",col.as_str(), n?);
            if game.cubes.contains_key(col.as_str()){
            }else {
                game.cubes.insert(col.as_str().to_string(),Cube{color:col, count:0});
            }
            game.cubes.get(col.as_str()).unwrap().increment(n?);
        }
        games.insert(gamestr[1].to_string(), game);
        //println!("Game {:?}  ",games);
        //}
        let v2: Vec<String> = safe_line.split(";").map(|s| s.to_string()).collect();
    }
    println!("Grand sum {} ",grandsum);
    Ok(())
}

fn main() {

    let _ = parse_input("./src/sample.txt");
}
