import json
import os
import strutils

func part1(nums: seq[int]): string =
    var prev = nums[0]
    var numIncreases = 0
    for i in 1 .. high(nums):
        if nums[i] > prev:
            numIncreases += 1
        prev = nums[i]
    return $numIncreases

func part2(nums: seq[int]): string =
    var prevSumWindow = nums[0] + nums[1] + nums[2]
    var numIncreases = 0
    for i in 1 .. high(nums) - 2:
        let sumWindow = nums[i + 0] + nums[i + 1] + nums[i + 2]
        if sumWindow > prevSumWindow:
            numIncreases += 1
        prevSumWindow = sumWindow
    return $numIncreases

when isMainModule:
    var
        f: File
        nums: seq[int]
    let inputPath = if paramCount() > 0: paramStr(1) else: "day1.txt"
    if open(f, inputPath):
        var line: string
        while f.readLine(line):
            nums.add(parseInt(line))
        let res1 = part1(nums)
        let res2 = part2(nums)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")