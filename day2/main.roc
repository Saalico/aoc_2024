app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import "numbers" as numbers : Str

input =
    Str.trim numbers
    |> Str.splitOn "\n"
    |> List.map \l -> Str.splitOn l " "
        |> List.keepOks Str.toI32
    |> List.keepIf \x -> !(List.isEmpty x)

isAscendingSafely = \l, sinc ->
    List.walkWithIndexUntil l (Pass, 0) \s, v, i ->
        next = List.get l (i + 1)
        when next is
            Ok n ->
                if ((n - v) <= sinc) && Num.isPositive (n - v) && n != v then
                    Continue (Pass, i)
                else
                    Break (Fail, i)

            _ -> Break s

isDescendingSafely = \l, sinc ->
    List.walkWithIndexUntil l (Pass, 0) \s, v, i ->
        next = List.get l (i + 1)
        when next is
            Ok n ->
                if ((v - n) <= sinc) && Num.isPositive (v - n) && n != v then
                    Continue (Pass, i)
                else
                    Break (Fail, i)

            _ -> Break s

retest = \ll, failPoint ->
    split = List.splitAt ll failPoint
    List.concat split.before (List.dropFirst split.others 1)

testWithTolerance = \ll, tests ->
    List.map ll \l ->
        List.map tests \t ->
            firstPass = t l 3
            if firstPass.0 == Fail then
                (
                    (t (retest l firstPass.1) 3).0
                    == Pass
                    || (t (retest l (firstPass.1 + 1)) 3).0
                    == Pass
                )
            else
                Bool.true
        |> List.countIf \x -> x
    |> List.sum

part1 = \ll ->
    List.countIf ll \l ->
        ((isAscendingSafely l 3).0 == Pass) || ((isDescendingSafely l 3).0 == Pass)

part2 = \ll -> testWithTolerance ll [isAscendingSafely, isDescendingSafely]

main =
    Stdout.line! "part 1: $(Num.toStr (part1 input)), part 2: $(Num.toStr (part2 input))"
