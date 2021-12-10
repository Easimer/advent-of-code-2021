import std/json
import std/sugar
import std/tables
import std/os
import std/algorithm

type
    CharKind = enum Opening, Closing
    CharValue = enum Paren, Bracket, Brace, Chevron
    Char = object
        kind: CharKind
        value: CharValue
    String = seq[Char]

func toChar(o: var Char, c: char): bool =
    o.kind = case c:
        of '(': Opening
        of ')': Closing
        of '[': Opening
        of ']': Closing
        of '{': Opening
        of '}': Closing
        of '<': Opening
        of '>': Closing
        else:
            return false

    o.value = case c:
        of '(': Paren
        of ')': Paren
        of '[': Bracket
        of ']': Bracket
        of '{': Brace
        of '}': Brace
        of '<': Chevron
        of '>': Chevron
        else:
            return false
    return true
            

func toString(o: var String, s: string): bool =
    var C: Char
    for ch in s:
        if not toChar(C, ch):
            return false
        o.add(C)
    return true

func charToScore(c: CharValue): int =
    case c:
        of Paren: 3
        of Bracket: 57
        of Brace: 1197
        of Chevron: 25137

func charToScore2(c: CharValue): int =
    case c:
        of Paren: 1
        of Bracket: 2
        of Brace: 3
        of Chevron: 4

func isCorrupted(s: String, badChar: var CharValue, stack: var seq[CharValue]): bool =
    stack.setLen(0)
    for c in s:
        case c.kind:
            of Opening:
                stack.add(c.value)
            of Closing:
                let top = stack.pop()
                if top != c.value:
                    stack.add(top)
                    badChar = c.value
                    return true
    return false

func part1(strings: seq[String]): string =
    var counter: Table[CharValue, int]
    var score = 0

    for s in strings:
        var stack: seq[CharValue]
        var badChar: CharValue
        if s.isCorrupted(badChar, stack):
            if badChar notin counter: counter[badChar] = 0
            counter[badChar] += 1
    
    for k, v in counter:
        score += charToScore(k) * v
    
    $score

func part2(strings: seq[String]): string =
    var incomplete: seq[seq[CharValue]]
    for s in strings:
        var stack: seq[CharValue]
        var badChar: CharValue
        if not s.isCorrupted(badChar, stack):
            incomplete.add(stack)
    
    var scores: seq[int]
    for stack in incomplete:
        var score = 0
        for i in countdown(high(stack), 0):
            let v = stack[i]
            score = score * 5 + charToScore2(v)
        scores.add(score)
    
    scores.sort()
    let middle = scores[len(scores) div 2]
    return $middle
        


when isMainModule:
    var
        f: File
        strings: seq[String]
        buf: String
    let inputPath = if paramCount() > 0: paramStr(1) else: "day10.txt"
    if open(f, inputPath):
        for line in f.lines:
            buf.setLen(0)
            if not toString(buf, line):
                assert(false)
            strings.add(buf)
        let res1 = part1(strings)
        let res2 = part2(strings)
        echo(%*{"output1": res1, "output2": res2})
