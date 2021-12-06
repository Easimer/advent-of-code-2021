import math
import json
import os
import strutils
import sugar

type
    LanternFish = uint8
    FishCounters = array[9, int]

# What I tried first
proc simulate(fishes: var seq[LanternFish]): void =
    var numAdd = 0
    for i in 0 .. high(fishes):
        if fishes[i] == 0:
            numAdd += 1
        else:
            fishes[i] -= 1
    
    while numAdd > 0:
        fishes.add(8)
        numAdd -= 1
    
proc simulate(fishes: var FishCounters, day: int): void =
    let f0 = fishes[0]
    var front: FishCounters

    front[6] = fishes[0] + fishes[7]
    front[5] = fishes[6]
    front[4] = fishes[5]
    front[3] = fishes[4]
    front[2] = fishes[3]
    front[1] = fishes[2]
    front[0] = fishes[1]
    front[7] = fishes[8]
    front[8] = f0

    fishes = front


func sizeOnDay(initialState: seq[LanternFish], day: int): int =
    var counters: FishCounters
    for num in initialState:
        counters[num] += 1
    for i in 0..day-1:
        simulate(counters, i)
    return sum(counters)

func part1(initialState: seq[LanternFish]): string =
    return $sizeOnDay(initialState, 80)

func part2(initialState: seq[LanternFish]): string =
    return $sizeOnDay(initialState, 256)


when isMainModule:
    var
        f: File
        initialState: seq[LanternFish]
        line: string
    let inputPath = if paramCount() > 0: paramStr(1) else: "day6.txt"
    if open(f, inputPath):
        if not f.readLine(line):
            echo("Couldn't read input file " & inputPath & "!")
            assert(false)
        
        initialState = collect(newSeq):
            for n in line.split(','):
                uint8(parseInt(n))

        let res1 = part1(initialState)
        let res2 = part2(initialState)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")
