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

  filterResults = findGas: rates: values:
    let
      filterResults' = rates: values: index:
        let
          lengthOfValues = builtins.length values;
          predAtIndex = value: "${toString (lib.elemAt rates index)}" == (lib.elemAt value index);
          newValues = lib.filter predAtIndex values;
          newRates = findRate findGas (builtins.foldl' stepRow startingAccs newValues);
        in if lengthOfValues == 1
          then lib.head values
        else if index >= (builtins.length rates)
          then throw "Have more than one value left: ${toString values}"
        else
          filterResults' newRates newValues  (index + 1);
    in filterResults' rates values 0;


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
  findOxygen = value: if value.one >= value.zero then 1 else 0;
  findCO2 = value: if value.one < value.zero then 1 else 0;

  oxygenRates = findRate findOxygen foldRates;
  CO2Rates = findRate findCO2 foldRates;

  oxygenResult = filterResults findOxygen oxygenRates sanitized;
  CO2Result = filterResults findCO2 CO2Rates sanitized;

  oxygenSum = binaryDigitsToSum (builtins.map lib.toInt oxygenResult);
  CO2Sum = binaryDigitsToSum (builtins.map lib.toInt CO2Result);
in
  oxygenSum * CO2Sum
