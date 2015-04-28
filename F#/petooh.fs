// PETOOH interpreter on F#
// Author: Kirill Smirenko, St. Petersburg State University

module Petooh

open System.IO

let memory_size = 65536
let val_inc = 1
let val_dec = 2
let ptr_inc = 3
let ptr_dec = 4
let loop_beg = 5
let loop_end = 6
let write = 7

let translate (str : string) =
  let subs (str : string) i =
      if str.Length > i then str.Substring i else ""
  let rec tr str =
    match str with
    | "" -> []
    | str when str.StartsWith "Ko" ->
      val_inc   :: (tr (subs str 2))
    | str when str.StartsWith "kO" ->
      val_dec   :: (tr (subs str 2))
    | str when str.StartsWith "Kudah" ->
      ptr_inc   :: (tr (subs str 5))
    | str when str.StartsWith "kudah" ->
      ptr_dec   :: (tr (subs str 5))
    | str when str.StartsWith "Kud" ->
      loop_beg  :: (tr (subs str 3))
    | str when str.StartsWith "kud" ->
      loop_end  :: (tr (subs str 3))
    | str when str.StartsWith "Kukarek" ->
      write     :: (tr (subs str 7))
    | _ -> tr (subs str 1)
  tr str |> List.toArray

let execute (print : string -> unit) (comms : int []) =
  let memory = Array.create memory_size 0uy
  let len = comms.Length
  let ptr = ref 0
  let rec findRightBracket i l =
    if i >= len then
      i
    else
      match comms.[i] with
      | x when x = loop_end ->
        if l = 0 then i else findRightBracket (i + 1) (l - 1)
      | x when x = loop_beg ->
        findRightBracket (i + 1) (l + 1)
      | _ -> findRightBracket (i + 1) l
  let rec exec i br =
    match i < len with
    | true ->
      match comms.[i] with
      | c when c = val_inc ->
        memory.[!ptr] <- memory.[!ptr] + 1uy
        exec (i + 1) br
      | c when c = val_dec ->
        memory.[!ptr] <- memory.[!ptr] - 1uy
        exec (i + 1) br
      | c when c = ptr_inc ->
        ptr := (!ptr + 1) % memory_size
        exec (i + 1) br
      | c when c = ptr_dec ->
        ptr := (!ptr + memory_size - 1) % memory_size
        exec (i + 1) br
      | c when c = loop_beg ->
        match br with
        | (l, r) :: t when l = i ->
          match compare (memory.[!ptr]) 0uy with
          | 0 -> exec (r + 1) t
          | _ -> exec (i + 1) br
        | _ ->
          let r = findRightBracket (i + 1) 0
          match compare (memory.[!ptr]) 0uy with
          | 0 -> exec (r + 1) br
          | _ -> exec (i + 1) ((i, r) :: br)
      | c when c = loop_end ->
        match br with
        | (l, _) :: t -> exec l br
        | _ -> ()
      | c when c = write ->
        print ((char memory.[!ptr]).ToString())
        exec (i + 1) br
      | _ ->
        exec (i + 1) br
    | false -> ()
  exec 0 []

let interpret (print : string -> unit) (filename : string) =
  try
    use streamIn = new StreamReader(filename)
    streamIn.ReadToEnd () |> translate |> (execute print)
  with
  | ex -> printfn "%A" ex.Message

[<EntryPoint>]
let main argv = 
  if argv.Length = 1 then
    interpret (printf "%s") (argv.[0])
  else
    printfn "Usage: $ petooh.exe <PETOOH file name>"
  0