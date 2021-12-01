with import <nixpkgs> { };

let
  input = builtins.readFile ./input.txt;
  strings = lib.splitString "\n" input;
  sanitized = lib.filter (s: s != "") strings;
  numbers = builtins.map (s: lib.toInt s) sanitized;
  differences = lib.zipListsWith (n1: n2: n2 - n1) numbers (lib.tail numbers);
in
  builtins.length (lib.filter (n: n > 0) differences)

