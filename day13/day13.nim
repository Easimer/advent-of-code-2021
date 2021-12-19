import std/sets
import std/sugar
import std/strscans
import std/os
import std/json

type
    Coord = (int, int)
    DotSet = HashSet[Coord]
    Axis = enum AxisX, AxisY
    Fold = object
        axis: Axis
        at: int
    Instructions = seq[Fold]

proc read(f: File, dotSet: var DotSet): bool =
    dotSet = collect:
        for line in f.lines:
            if len(line) == 0:
                break

            var x, y: int
            if scanf(line, "$i,$i", x, y):
                {(x, y)}
    true

proc read(f: File, instr: var Instructions): bool =
    instr = collect:
        for line in f.lines:
            var c: char
            var n: int
            if scanf(line, "fold along $c=$i", c, n):
                let axis = case c:
                    of 'x': AxisX
                    of 'y': AxisY
                    else: AxisY
                Fold(axis: axis, at: n)
    
    true

func foldY(dotSet: DotSet, at: int): DotSet =
    for dot in dotSet:
        if dot[1] > at:
            let dist = dot[1] - at
            let nextY = at - dist
            result.incl((dot[0], nextY))
        else:
            result.incl(dot)

func foldX(dotSet: DotSet, at: int): DotSet =
    for dot in dotSet:
        if dot[0] > at:
            let dist = dot[0] - at
            let nextX = at - dist
            result.incl((nextX, dot[1]))
        else:
            result.incl(dot)

func fold(dotSet: DotSet, fold: Fold): DotSet =
    case fold.axis:
        of AxisX: foldX(dotset, fold.at)
        of AxisY: foldY(dotset, fold.at)

func `$`(dots: DotSet): string =
    var maxX = 0
    var maxY = 0
    for (x, y) in dots:
        if x > maxX: maxX = x
        if y > maxY: maxY = y
    for y in 0..maxY:
        for x in 0..maxX:
            if (x, y) in dots:
                result.add('#')
            else:
                result.add('.')
        result.add('\n')

func part1(dots: DotSet, instructions: Instructions): string =
    let i0 = instructions[0]
    let res = fold(dots, i0)
    $len(res)
func part2(dots: DotSet, instructions: Instructions): string =
    var cur = dots
    for instr in instructions:
        cur = fold(cur, instr)
    $cur

when isMainModule:
    var
        f: File
        dots: DotSet
        instructions: Instructions
    let inputPath = if paramCount() > 0: paramStr(1) else: "day13.txt"
    if open(f, inputPath):
        if not f.read(dots):
            echo("Invalid input 1")
        if not f.read(instructions):
            echo("Invalid input 2")
        let res1 = part1(dots, instructions)
        let res2 = part2(dots, instructions)
        echo(%*{"output1": res1, "output2": res2})

