import json
import os
import strutils
import sugar

type
    Point = object
        x, y: int
    Line = object
        p0, p1: Point

const WIDTH = 1000
const HEIGHT = 1000

iterator pointsOf(line: Line): Point =
    var x = line.p0.x
    var y = line.p0.y
    let dx = line.p1.x - line.p0.x
    let dy = line.p1.y - line.p0.y
    let stepx = if dx == 0: 0 else: int(dx / abs(dx))
    let stepy = if dy == 0: 0 else: int(dy / abs(dy))

    while int(x) != line.p1.x or int(y) != line.p1.y:
        yield Point(x: x, y: y)
        x += stepx
        y += stepy
    yield line.p1

func countOverlaps(lines: seq[Line]): int =
    var field = newSeq[int](WIDTH * HEIGHT)

    for line in lines:
        for point in pointsOf(line):
            field[point.y * WIDTH + point.x] += 1
    
    for v in field:
        if v >= 2:
            result += 1

func part1(lines: seq[Line]): string =
    let nonDiagonals = collect(newSeq):
        for line in lines:
            if line.p0.x == line.p1.x or line.p0.y == line.p1.y:
                line
    return $countOverlaps(nonDiagonals)

func part2(lines: seq[Line]): string =
    return $countOverlaps(lines)

func parsePoint(s: string): Point =
    let c = s.split(',')
    result.x = parseInt(c[0])
    result.y = parseInt(c[1])

proc readLine(line: var Line, f: File): bool =
    var buf: string
    if not f.readLine(buf):
        return
    let points = buf.split(" -> ")
    line.p0 = parsePoint(points[0])
    line.p1 = parsePoint(points[1])
    true

when isMainModule:
    var
        f: File
        line: Line
        lines: seq[Line]
    let inputPath = if paramCount() > 0: paramStr(1) else: "day5.txt"
    if open(f, inputPath):
        while readLine(line, f):
            lines.add(line)
        let res1 = part1(lines)
        let res2 = part2(lines)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")