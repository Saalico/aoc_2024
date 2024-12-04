app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout

import "input_sample" as input : Str
# import "input" as input : Str

in =
    Str.splitOn input "\n"
    |> List.map \x -> Str.toUtf8 x

join = \lx, ly ->
    List.map2 lx ly \x, y -> (x, y)

getSteps = \start, end, path ->
    if List.isEmpty path then
        getSteps start end [start]
    else if start == end then
        List.append path end
    else if start < end then
        getSteps (start + 1) end (List.append path (start + 1))
    else
        getSteps (start - 1) end (List.append path (start - 1))

getStraightPath = \start, end ->
    xpath = getSteps start.0 end.0 []
    ypath = getSteps start.1 end.1 []
    if (List.len xpath == List.len ypath) then
        join xpath ypath
    else
        []

extractString = \ll, path ->
    List.walkUntil path [] \s, v ->
        row = (List.get ll v.1) |> Result.withDefault []
        if !(List.isEmpty row) then
            column = List.get row v.0
            if Result.isOk column then
                Continue (List.append s column)
            else
                Break s
        else
            Break s

lookForString = \sample, target ->
    List.walkWithIndexUntil sample Pass \_s, v, i ->
        dbg (v, i)

        if v == (List.get target i |> Result.withDefault 0) then
            Continue Pass
        else
            Break Fail

main =
    dbg (lookForString (Str.toUtf8 "XMAS") (List.keepOks (extractString in (getStraightPath (0, 4) (3, 4))) \x -> x))

    dbg (getStraightPath (0, 4) (3, 4))

    dbg (Str.toUtf8 "XMAS")

    Stdout.line! "sup"
