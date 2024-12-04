app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import "input" as input : Str

closeToken = Str.toUtf8 "1234567890,"

mulString = \string ->
    split = Str.splitOn string ","
    when split is
        [a, b] -> Ok (Str.toI32? (a) * Str.toI32? (b))
        _ -> Err InvalidString

part1 = \in ->
    Str.splitOn in ")"
    |> List.joinMap \x ->
        if Str.contains x "mul(" then
            Str.splitOn x "mul("
        else
            [""]
    |> List.keepIf \chunk -> (List.all (Str.toUtf8 chunk) \c -> List.contains closeToken c) && !(Str.isEmpty chunk)
    |> List.keepOks \x -> mulString x
    |> List.sum

part2 =
    Str.splitOn input "do()"
    |> List.keepOks \x -> Str.splitOn x "don't()" |> List.first
    |> List.walk "" \str, s -> Str.concat str s
    |> part1

main =
    Stdout.line! "part1: $(Num.toStr part2) part2: $(Num.toStr (part1 input))"

