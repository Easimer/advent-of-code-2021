import json
import os
import strutils

type
    CommandKind = enum
        kUnknown,
        kForward,
        kUp,
        kDown
    
    Command = object
        kind: CommandKind
        step: int

func parseLine(line: string): Command =
    let splitting = split(line, ' ')

    assert(len(splitting) >= 2)

    result.kind = case splitting[0]:
        of "forward": kForward
        of "up": kUp
        of "down": kDown
        else: kUnknown
    
    result.step = parseInt(splitting[1])

func part1(cmds: seq[Command]): string =
    var horizontal = 0
    var depth = 0

    for cmd in cmds:
        case cmd.kind:
            of kForward:
                horizontal += cmd.step
            of kUp:
                depth -= cmd.step
            of kDown:
                depth += cmd.step
            of kUnknown:
                assert(false)
    return $(horizontal * depth)

func part2(cmds: seq[Command]): string =
    var horizontal = 0
    var depth = 0
    var aim = 0

    for cmd in cmds:
        case cmd.kind:
            of kForward:
                horizontal += cmd.step
                depth += aim * cmd.step
            of kUp:
                aim -= cmd.step
            of kDown:
                aim += cmd.step
            of kUnknown:
                assert(false)
    return $(horizontal * depth)

when isMainModule:
    var
        f: File
        cmds: seq[Command]
    let inputPath = if paramCount() > 0: paramStr(1) else: "day2.txt"
    if open(f, inputPath):
        var line: string
        while f.readLine(line):
            cmds.add(parseLine(line))
        let res1 = part1(cmds)
        let res2 = part2(cmds)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")
