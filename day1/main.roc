app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import "numbers" as numbers : Str

listStr =
    numbers
    |> Str.replaceEach "   " ","
    |> Str.replaceEach "\n" ","
    |> Str.splitOn ","

list =
    listStr
    |> List.keepOks Str.toI32

seperated = List.walkWithIndex list ([], []) \tree, value, index ->
    if Num.isEven (index) then
        (List.append tree.0 value, tree.1)
    else
        (tree.0, List.append tree.1 value)

sorted = \tree ->
    (List.sortAsc tree.0, List.sortAsc tree.1)

segment = \sortedTree ->
    List.map2 sortedTree.0 sortedTree.1 Line

getMagnitude = \a, b ->
    c = a - b
    if Num.isNegative c then
        c * -1
    else
        c

getDistance = \segmentedList ->
    List.map segmentedList \x ->
        when x is
            Line a b -> getMagnitude a b
            _ -> crash "Invalid/corrupted data supplied"

increaseCount = \v ->
    when v is
        Ok val -> Ok (val + 1)
        Err Missing -> Err Missing

countOccurences = \l ->

    List.walk l (Dict.empty {}) \d, v ->
        if Dict.contains d v then
            Dict.update d v increaseCount
        else
            Dict.insert d v 1

getSimilarity = \l, d ->
    List.map l \i ->
        occ = Dict.get d i
        when occ is
            Ok a -> i * a
            _ -> 0
main =
    tree =
        sorted seperated

    dbg (List.sum (getSimilarity tree.0 (countOccurences tree.1)))

    Stdout.line! "sup"
