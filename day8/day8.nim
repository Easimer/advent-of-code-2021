import sugar
import strutils
import os
import json
import options
import std/tables

type
    Segment = 'a'..'g'
    Wire = 'a'..'g'
    Segments = set['a'..'g']
    RawDigit = set['a'..'g']
    Digit = set['a'..'g']
    Entry = object
        lhs: array[10, RawDigit]
        rhs: array[4, RawDigit]
    Knowledge = object
        map: Table[Segment, set[Wire]]
    SegmentWireMap = Table[Segment, Wire]

# Compute active segment sets for each digit
const DIGIT_8: Digit = {'a'..'g'}
const DIGIT_0 = DIGIT_8 - {'d'}
const DIGIT_1: Digit = {'c', 'f'}
const DIGIT_2 = DIGIT_8 - {'b', 'f'}
const DIGIT_3 = DIGIT_8 - {'b', 'e'} 
const DIGIT_4 = DIGIT_8 - {'a', 'e', 'g'}
const DIGIT_5 = DIGIT_8 - {'c', 'e'}
const DIGIT_6 = DIGIT_8 - {'c'}
const DIGIT_7: Digit = {'a', 'c', 'f'}
const DIGIT_9 = DIGIT_8 - {'e'}

iterator segments(): 'a'..'g' =
    for c in 'a'..'g':
        yield c

func initDigit(s: string): RawDigit =
    for c in s:
        if c in 'a'..'g':
            result.incl(c)
        else:
            assert(false)

func initKnowledge(): Knowledge =
    var s: set[Segment] = {'a'..'g'}
    for c in segments():
        result.map[c] = s

proc readLine(f: File, outEntry: var Entry): bool =
    var line: string
    if not f.readLine(line):
        return false
    
    let twoSides = line.split('|')
    let lhs = collect(newSeq):
        for sDigit in twoSides[0].strip().split(' '):
            initDigit(sDigit.strip())
    let rhs = collect(newSeq):
        for sDigit in twoSides[1].strip().split(' '):
            initDigit(sDigit.strip())
    assert(len(lhs) == 10)
    assert(len(rhs) == 4)
    
    for i in 0..high(outEntry.lhs):
        outEntry.lhs[i] = lhs[i]
    for i in 0..high(outEntry.rhs):
        outEntry.rhs[i] = rhs[i]

    return true

func isAmbigious(K: Knowledge): bool =
    for v in K.map.values:
        assert(card(v) > 0)
        if card(v) != 1:
            return true
    return false

iterator sum[L, R, T](lhs: array[L, T], rhs: array[R, T]): T =
    for v in lhs: yield v
    for v in rhs: yield v

func solve(entry: Entry): SegmentWireMap =
    var K = initKnowledge()
    for pattern in sum(entry.lhs, entry.rhs):
        let L = len(pattern)
        case L:
            of 2:
                K.map['c'] = K.map['c'] * pattern
                K.map['f'] = K.map['f'] * pattern
            of 3:
                K.map['a'] = K.map['a'] * pattern
                K.map['c'] = K.map['c'] * pattern
                K.map['f'] = K.map['f'] * pattern
            of 4:
                K.map['b'] = K.map['b'] * pattern
                K.map['c'] = K.map['c'] * pattern
                K.map['d'] = K.map['d'] * pattern
                K.map['f'] = K.map['f'] * pattern
            of 5:
                for c in segments():
                    if c notin pattern:
                        K.map['a'].excl(c)
                        K.map['d'].excl(c)
                        K.map['g'].excl(c)
            of 6:
                for c in segments():
                    if c notin pattern:
                        K.map['a'].excl(c)
                        K.map['b'].excl(c)
                        K.map['f'].excl(c)
                        K.map['g'].excl(c)
            of 7:
                K.map['a'] = K.map['a'] * pattern
                K.map['b'] = K.map['b'] * pattern
                K.map['c'] = K.map['c'] * pattern
                K.map['d'] = K.map['d'] * pattern
                K.map['e'] = K.map['e'] * pattern
                K.map['f'] = K.map['f'] * pattern
                K.map['g'] = K.map['g'] * pattern
            else:
                discard
        for v in K.map.values:
            assert(len(v) != 0)

    while isAmbigious(K):
        var g: Segments
        for k, v in K.map.pairs:
            if card(v) == 1:
                g.incl(v)
        for k, v in K.map.mpairs:
            if card(v) != 1:
                v = v - g

    for k, v in K.map.pairs:
        assert(card(v) == 1)
        for c in v:
            result[c] = k

func resolveDigit(M: SegmentWireMap, digit: RawDigit): Digit =
    for c in digit:
        result.incl(M[c])

func validateDigit(d: Digit) =
    assert(d == DIGIT_0 or d == DIGIT_1 or d == DIGIT_2 or d == DIGIT_3 or d == DIGIT_4 or d == DIGIT_5 or d == DIGIT_6 or d == DIGIT_7 or d == DIGIT_8 or d == DIGIT_9)

func validateMapping(lhs: openArray[Digit], mapping: SegmentWireMap) =
    for d in lhs:
        validateDigit(resolveDigit(mapping, d))

func digit2value(digit: Digit): int =
    if digit == DIGIT_0: return 0
    if digit == DIGIT_1: return 1
    if digit == DIGIT_2: return 2
    if digit == DIGIT_3: return 3
    if digit == DIGIT_4: return 4
    if digit == DIGIT_5: return 5
    if digit == DIGIT_6: return 6
    if digit == DIGIT_7: return 7
    if digit == DIGIT_8: return 8
    if digit == DIGIT_9: return 9

func part1(entries: seq[Entry]): string =
    var counter = 0
    for entry in entries:
        let mapping = solve(entry)
        validateMapping(entry.lhs, mapping)
        for rawDigit in entry.rhs:
            let digit = resolveDigit(mapping, rawDigit)
            validateDigit(digit)
            if digit == DIGIT_1 or digit == DIGIT_4 or digit == DIGIT_7 or digit == DIGIT_8:
                counter += 1
    return $counter

func part2(entries: seq[Entry]): string =
    var sum = 0
    for entry in entries:
        let mapping = solve(entry)
        var number = 0
        for rawDigit in entry.rhs:
            let digit = resolveDigit(mapping, rawDigit)
            number *= 10
            number += digit2value(digit)
        sum += number
    return $sum


when isMainModule:
    var
        f: File
        entries: seq[Entry]
        entry: Entry
    let inputPath = if paramCount() > 0: paramStr(1) else: "day8.txt"
    if open(f, inputPath):
        while f.readLine(entry):
            entries.add(entry)
        let res1 = part1(entries)
        let res2 = part2(entries)
        echo(%*{"output1": res1, "output2": res2})

