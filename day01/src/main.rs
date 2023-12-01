use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufReader};
use std::io::prelude::*;
//use regex::Regex;
use lazy_static::lazy_static;
//use fancy_regex::Regex;
use onig::Regex;


fn replace_strnumb(strnum: &str)-> Result<i64, String>  {
        let b  =match strnum {
        "one" => 1,"two"=>2,"three"=> 3,"four"=> 4,"five"=> 5,"six"=>6,"seven"=> 7,
            "eight"=>8,"nine" => 9,
            _ => 0
        };
    Ok(b)
}
fn parse_input(filepath: &str) -> Result<(), Box<dyn std::error::Error>> {

      let file = File::open(filepath)?;
      let reader = BufReader::new(file);
      let mut grandsum: i64=0;
      for line in reader.lines() {
          let (mut first, mut last) = (-1, -1);
          let x=line?;
          lazy_static! {
                static ref RE: Regex = Regex::new(r"(?=(one|two|three|four|five|six|seven|eight|nine|[1-9]))").unwrap();
             }
           let matches = RE.captures_iter(&x);
            for cap in matches{
                for vs in cap.iter().flatten() {
                    if vs=="" {continue;}  // Why do we get empty strings?
                    let test = vs.parse::<i64>();
                    match test {
                        Ok(ok) => {
                            if first == -1 { first = ok; }
                            last = ok;
                        },
                        Err(e) => {
                            let numb = replace_strnumb(vs)?;
                            if first == -1 { first = numb; }
                            last = numb;
                        },
                    }
                }
          }
          grandsum=grandsum + (first*10 + last)
      }
     println!("Grand sum {} ",grandsum);
     Ok(())
  }
fn main() {
      let _ = parse_input("./src/input.txt");
  }


