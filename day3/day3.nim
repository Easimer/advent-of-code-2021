import json
import os
import strutils
import sugar

type
    BitCounter = object
        zeros: int
        ones: int

func gammaBit(counter: BitCounter): int =
    if counter.ones >= counter.zeros:
        1
    else:
        0

func epsilonBit(counter: BitCounter): int =
    if counter.ones < counter.zeros:
        1
    else:
        0

func computeCounter(p: int, cmds: seq[string]): BitCounter =
    result.ones = 0
    result.zeros = 0

    for cmd in cmds:
        if cmd[p] == '1':
            result.ones += 1
        else:
            result.zeros += 1

func computeCounters(cmds: seq[string]): seq[BitCounter] =
    let numPlaces = len(cmds[0])
    for i in 0 .. numPlaces - 1:
        result.add(computeCounter(i, cmds))

func part1(cmds: seq[string]): string =
    let counters = computeCounters(cmds)

    var gamma = 0
    var epsilon = 0
    for counter in counters:
        gamma = gamma shl 1
        epsilon = epsilon shl 1
        gamma += counter.gammaBit()
        epsilon += counter.epsilonBit()
    
    return $(gamma * epsilon)

func part2filter(cmds: seq[string], f: (counter: BitCounter) -> int): string =
    let numPlaces = len(cmds[0])
    var cur = cmds
    for p in 0 .. numPlaces - 1:
        let counter = computeCounter(p, cur)
        let bit = ($(f(counter)))[0]

        if len(cur) > 1:
            cur = collect(newSeq):
                for cmd in cur:
                    if cmd[p] == bit: cmd
    return cur[0]

func part2(cmds: seq[string]): string =
    let oxy = parseBinInt(part2filter(cmds, gammaBit))
    let co2 = parseBinInt(part2filter(cmds, epsilonBit))
    return $(oxy * co2)

when isMainModule:
    var
        f: File
        cmds: seq[string]
    let inputPath = if paramCount() > 0: paramStr(1) else: "day3.txt"
    if open(f, inputPath):
        var line: string
        while f.readLine(line):
            cmds.add(line)
        let res1 = part1(cmds)
        let res2 = part2(cmds)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")
