use anyhow::{anyhow, Result};
use log::{debug, trace};
use smallvec::SmallVec;
use smol_str::SmolStr;

const OP_INCPTR: &str = "Kudah";
const OP_DECPTR: &str = "kudah";
const OP_INC: &str = "Ko";
const OP_DEC: &str = "kO";
const OP_OUT: &str = "Kukarek";
const OP_JMP: &str = "Kud";
const OP_RET: &str = "kud";
const VALID_CHARS: [char; 10] = ['a', 'd', 'e', 'h', 'k', 'K', 'o', 'O', 'r', 'u'];

fn main() -> Result<()> {
    if std::env::var_os("LOG").is_none() {
        std::env::set_var("LOG", "error")
    }
    env_logger::init_from_env("LOG");

    let script_path = match std::env::args().nth(1) {
        Some(e) => e,
        None => return Err(anyhow!("path not provided")),
    };
    let file = std::fs::read_to_string(script_path)?;

    parse(&file, &mut Stack::new())
}

type Vector<T> = SmallVec<[T; 16]>;

#[derive(Debug)]
struct Stack {
    cells: Vector<usize>,
    cellptr: usize,
    stack: Vector<Vector<SmolStr>>,
    level: usize,
}

impl Stack {
    fn new() -> Stack {
        let mut cells = SmallVec::new();
        cells.extend(std::iter::repeat(0).take(16));
        let mut stack = SmallVec::new();
        stack.extend(std::iter::repeat(SmallVec::new()).take(16));
        Stack {
            cellptr: 0,
            cells,
            stack,
            level: 0,
        }
    }

    fn push(&mut self, instr: &str) {
        self.stack[self.level].push(instr.into());
    }

    fn loops(&mut self) {
        while self.cells[self.cellptr] > 0 {
            for instr in self.stack.get(self.level).unwrap() {
                match instr.as_str() {
                    OP_INC => self.cells[self.cellptr] += 1,
                    OP_DEC => self.cells[self.cellptr] -= 1,
                    OP_INCPTR => self.cellptr += 1,
                    OP_DECPTR => self.cellptr -= 1,
                    o => panic!("unknown operation: {o}"),
                }
            }
        }
    }
}

fn parse(code: &str, stack: &mut Stack) -> Result<()> {
    let mut buffer = String::new();
    let code: String = code
        .chars()
        .filter(|ch| !VALID_CHARS.iter().all(|c| ch != c))
        .collect();

    for (n, ch) in code.chars().enumerate() {
        let inst = buffer.clone() + &ch.to_string();
        debug!("Loop :: {n}, Instruction :: {inst}, Buffer :: {buffer}");
        trace!("Stack :: {stack:?}");

        match inst.as_str() {
            OP_INC => {
                buffer.clear();

                if stack.level > 0 {
                    stack.push(&inst);
                } else {
                    stack.cells[stack.cellptr] += 1;
                }
            }

            OP_DEC => {
                buffer.clear();

                if stack.level > 0 {
                    stack.push(&inst);
                } else {
                    stack.cells[stack.cellptr] -= 1;
                }
            }

            OP_INCPTR => {
                buffer.clear();

                if stack.level > 0 {
                    stack.push(&inst)
                } else {
                    stack.cellptr += 1;
                }
            }

            OP_DECPTR => {
                buffer.clear();

                if stack.level > 0 {
                    stack.push(&inst)
                } else {
                    stack.cellptr -= 1;
                }
            }

            OP_OUT => {
                buffer.clear();
                if stack.level > 0 {
                    stack.push(&inst)
                } else {
                    print!(
                        "{}",
                        char::from_u32(stack.cells[stack.cellptr].try_into().unwrap()).unwrap()
                    );
                }
            }

            _ => {
                if buffer == OP_JMP && ch != 'a' {
                    buffer = ch.to_string();
                    stack.level += 1;
                    stack.stack[stack.level] = SmallVec::new();
                } else if buffer == OP_RET && ch != 'a' {
                    buffer = ch.to_string();
                    stack.loops();
                    stack.level -= 1;
                } else {
                    buffer.push(ch);
                }
            }
        }
    }
    Ok(())
}
