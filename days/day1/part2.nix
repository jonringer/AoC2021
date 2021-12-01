with import <nixpkgs> { };

let
  # read file into [ Int ]
  input = builtins.readFile ./input.txt;
  strings = lib.splitString "\n" input;
  sanitized = lib.filter (s: s != "") strings;
  numbers = builtins.map (s: lib.toInt s) sanitized;

  # create the window of values
  numbers' = lib.tail numbers;
  numbers'' = lib.tail numbers';
  zipAdd = lib.zipListsWith (n1: n2: n2 + n1);
  zipSub = lib.zipListsWith (n1: n2: n2 - n1);
  window = zipAdd numbers numbers';
  window' = zipAdd window numbers'';

  # find the differneces
  differences = zipSub window' (lib.tail window');
in
  builtins.length (lib.filter (n: n > 0) differences)

