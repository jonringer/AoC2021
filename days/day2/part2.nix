with import <nixpkgs> { };

let
  startingPosition = { depth = 0; aim = 0; distance = 0; };
  input = builtins.readFile ./input.txt;
  strings = lib.splitString "\n" input;
  sanitized = lib.filter (s: s != "") strings;

  step = acc: next: let
    values = lib.splitString " " next;
    command = lib.elemAt values 0;
    distance = lib.toInt (lib.elemAt values 1);
  in if command == "forward" then
    acc // { distance = acc.distance + distance; depth = acc.depth + (acc.aim * distance); }
  else if command == "up" then
    acc // { aim = acc.aim - distance; }
  else if command == "down" then
    acc // { aim = acc.aim + distance; }
  else
  throw "something wrong happened. ${next}";

  applyMoves = builtins.foldl' step startingPosition sanitized;
in
  applyMoves.distance * applyMoves.depth

