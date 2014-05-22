use std::os;
use std::io::BufferedReader;
use std::io::File;
use std::io;

#[deriving(Show)]
enum State {
    RTagOpen,
    RTagJustOpen,
    RTagClose,
    RMain
}

fn process(name : &str) {

    let path = Path::new(name);
    let mut reader = BufferedReader::new(File::open(&path));
    let mut out = io::stdout();

    let mut state = RMain;
    let mut buf = [0, ..4096];
    let mut tags : Vec<~str> = Vec::new();
    let mut cur_text : Vec<u8> = Vec::new();

    while reader.read(buf).is_ok() {
        for c in buf.iter() {
            match (state, *c as char) {
                (RMain, '<' ) => {
                    if tags.pop() == Some("ProductUrl".to_owned()) {
                        let _ = out.write(cur_text.as_slice());
                        let _ = out.write_line("");
                    }
                    cur_text = Vec::new();
                    state = RTagJustOpen;
                }
                (RMain, _) =>
                    cur_text.push(*c),
                (RTagJustOpen, '/') =>
                    state = RTagClose,
                (RTagJustOpen, _) => {
                    cur_text.push(*c);
                    state = RTagOpen;
                }
                (RTagOpen, '>') => {
                    let v = std::str::from_utf8(cur_text.as_slice()).unwrap().to_owned();
                    tags.push(v);
                    cur_text = Vec::new();
                    state = RMain;
                }
                (RTagOpen, '/') =>
                    state = RMain,
                (RTagOpen, _) =>
                    cur_text.push(*c),
                (RTagClose, '>') => {
                    let _ = tags.pop();
                    state = RMain;
                }
                (RTagClose, _) =>
                    { }
            }
        }
    }
}

fn main() {
    let mut argv = os::args();
    let prog = argv.shift().unwrap();
    let filename = argv.shift();
    match filename {
        None => {
            println!("Usage: {} <filename>", prog);
        }
        Some(name) => {
            process(name);
        }
    }
}
