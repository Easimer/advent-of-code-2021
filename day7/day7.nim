import sugar
import strutils
import os
import json
import options

type
    CostFunction = (crabs: seq[int], target: int) -> int

func cost(crabs: seq[int], target: int): int =
    result = 0
    for crab in crabs:
        result += abs(crab - target)

func cost2(crabs: seq[int], target: int): int =
    result = 0
    for crab in crabs:
        let dist = abs(crab - target)
        # closed form of sum from 1 to dist
        let cost = dist * (dist + 1) div 2
        result += cost

func findMinimalCost(crabs: seq[int], cost: CostFunction): int =
    var dir = none[int]()
    var cur = 0
    var costCurrent = 0

    while dir != some(0):
        costCurrent = cost(crabs, cur)
        let costLeft = cost(crabs, cur - 1)
        let costRight = cost(crabs, cur + 1)

        if costLeft < costCurrent and costLeft < costRight:
            dir = some(-1)
        elif costRight < costCurrent and costRight < costLeft:
            dir = some(1)
        else:
            dir = some(0)

        # debugEcho(%*{"cur": cur, "dir": dir, "cc": costCurrent, "cl": costLeft, "cr": costRight})
        
        cur += get(dir)

    costCurrent

func part1(crabs: seq[int]): string =
    return $(findMinimalCost(crabs, cost))

func part2(crabs: seq[int]): string =
    return $(findMinimalCost(crabs, cost2))

when isMainModule:
    var
        f: File
        line: string
        crabs: seq[int]
    let inputPath = if paramCount() > 0: paramStr(1) else: "day7.txt"
    if open(f, inputPath):
        if not f.readLine(line):
            echo("Couldn't read input file " & inputPath & "!")
            assert(false)
        
        crabs = collect(newSeq):
            for s in line.split(','):
                parseInt(s)

        let res1 = part1(crabs)
        let res2 = part2(crabs)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")
        