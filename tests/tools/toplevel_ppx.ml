let () =
  if Array.length Sys.argv < 3 then begin
    let name = Filename.basename Sys.executable_name in
    Printf.eprintf "usage: %s <input files> <toplevel>\n%!" name;
    exit 1
  end

let input = Sys.argv.(1)
let toplevel = Sys.argv.(2)

let args =
  [""; "-noprompt"; "-no-version"; "-ppx"; Printf.sprintf "%s --as-ppx" (if Sys.win32 then "ppx.exe" else "./ppx.exe")]

let () =
  let input_fd = Unix.openfile input [O_RDONLY] 0 in
  begin
    let pid = Unix.create_process toplevel (Array.of_list args) input_fd Unix.stdout Unix.stderr in
    let _, _ = Unix.waitpid [] pid in
    Unix.close input_fd;
    exit 0
  end
