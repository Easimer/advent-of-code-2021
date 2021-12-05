import json
import os
import strutils
import sugar
import std/sets

type
    Point = object
        x, y: int
    Line = object
        p0, p1: Point

iterator pointsOf(line: Line): Point =
    var x = float(line.p0.x)
    var y = float(line.p0.y)
    var prevx = -1
    var prevy = -1
    let dx = line.p1.x - line.p0.x
    let dy = line.p1.y - line.p0.y
    let stepx = if dx == 0: 0.0 else: float(dx) / abs(float(dx))
    let stepy = if dy == 0: 0.0 else: float(dy) / abs(float(dy))

    while int(x) != line.p1.x or int(y) != line.p1.y:
        let xi = int(x)
        let yi = int(y)
        if xi != prevx or yi != prevy:
            yield Point(x: xi, y: yi)
            prevx = xi
            prevy = yi
        x += stepx
        y += stepy
    yield line.p1

func part1(lines: seq[Line]): string =
    let WIDTH = 1000
    let HEIGHT = 1000
    var field = newSeq[int](WIDTH * HEIGHT)

    let simpleLines = collect(newSeq):
        for line in lines:
            if line.p0.x == line.p1.x or line.p0.y == line.p1.y:
                line
    
    for line in simpleLines:
        for point in pointsOf(line):
            field[point.y * WIDTH + point.x] += 1
    
    var counter = 0
    for v in field:
        if v >= 2:
            counter += 1
    return $counter


func part2(lines: seq[Line]): string =
    let WIDTH = 1000
    let HEIGHT = 1000
    var field = newSeq[int](WIDTH * HEIGHT)

    for line in lines:
        for point in pointsOf(line):
            field[point.y * WIDTH + point.x] += 1
    
    var counter = 0
    for v in field:
        if v >= 2:
            counter += 1
    return $counter

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