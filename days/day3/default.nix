with import <nixpkgs> { };

let
  startingAccs = [
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
    { one = 0; zero = 0; }
  ];
  exponents = lib.reverseList (lib.lists.range 0 11);

  input = builtins.readFile ./input.txt;
  strings = lib.splitString "\n" input;
  characters = builtins.map (s: lib.strings.stringToCharacters s) strings;
  sanitized = lib.filter (l: l != [ ]) characters;

  step = acc: char:
    if char == "0" then
      acc // { zero = acc.zero + 1; }
    else if char == "1" then
      acc // { one = acc.one + 1; }
    else
    throw "something wrong happened. ${char}";

  stepRow = lib.zipListsWith step;
  foldRates = builtins.foldl' stepRow startingAccs sanitized;

  pow =
    let
      pow' = base: exponent: value:
        if exponent == 0
        then 1
        else if exponent <= 1
        then value
        else (pow' base (exponent - 1) (value * base));
    in base: exponent: pow' base exponent base;

  # [ Int ] -> Int
  binaryDigitsToSum = digits: let
    sum = builtins.foldl' (a: b: a + b) 0;
    digitToDecimal = lib.zipListsWith (exp: digit: if digit == 0 then 0 else pow 2 exp) exponents digits;
  in sum digitToDecimal;

  findRate = comp: rates: builtins.map comp rates;
  findGamma = value: if value.one > value.zero then 1 else 0;
  findEpsilon = value: if value.one < value.zero then 1 else 0;

  gamma = binaryDigitsToSum (findRate findGamma foldRates);
  epsilon = binaryDigitsToSum (findRate findEpsilon foldRates);
in
  gamma * epsilon

