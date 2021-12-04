import json
import os
import strutils
import sugar
import std/sets

type
    NumberDrawing = seq[int]
    Board = object
        # Row-major
        cells: seq[int]

    PlayerState = object
        rows: seq[HashSet[int]]
        cols: seq[HashSet[int]]

    OnWinCallback[T] = ((number: int, player: PlayerState, user: var T) -> bool)

    Part1Result = string
    Part2PlayState = object
        playersLeft: int
        result: string


proc readNumberDrawing(outDrawing: var NumberDrawing, f: File): bool =
    var line: string
    if not f.readLine(line):
        return false

    outDrawing = collect(newSeq):
        for strNum in line.split(','):
            parseInt(strNum)
    true

proc readBoard(board: var Board, f: File): bool =
    var line: string

    board.cells.setLen(0)

    if not f.readLine(line) or len(line) != 0:
        return false

    for i in 0 .. 4:
        if not f.readLine(line):
            return false
        let cells = collect(newSeq):
            for strCell in line.split():
                if strCell.isEmptyOrWhitespace(): continue
                parseInt(strCell)
        for cell in cells:
            board.cells.add(cell)
    
    true

func sumUnmarked(player: PlayerState): int =
    result = 0
    for row in player.rows:
        for cell in row:
            result += cell

func play[T](numberDrawing: NumberDrawing, boards: openArray[Board], onWin: OnWinCallback[T], user: var T): void =
    var players = collect(newSeq):
        for board in boards:
            var rows: seq[HashSet[int]]
            var cols: seq[HashSet[int]]
            for row in 0 .. 4:
                rows.add(initHashSet[int]())
                for col in 0 .. 4:
                    rows[row].incl(board.cells[row * 5 + col])
            for col in 0 .. 4:
                cols.add(initHashSet[int]())
                for row in 0 .. 4:
                    cols[col].incl(board.cells[row * 5 + col])
            PlayerState(rows: rows, cols: cols)
    
    var hasAlreadyWon = initHashSet[int]()
    for number in numberDrawing:
        for idxPlayer in 0 .. high(boards):
            for row in 0 .. 4:
                players[idxPlayer].rows[row].excl(number)
                
            for col in 0 .. 4:
                players[idxPlayer].cols[col].excl(number)
            
            if not hasAlreadyWon.contains(idxPlayer):
                for row in 0 .. 4:
                    if len(players[idxPlayer].rows[row]) == 0:
                        if onWin(number, players[idxPlayer], user):
                            return
                        hasAlreadyWon.incl(idxPlayer)
                
            if not hasAlreadyWon.contains(idxPlayer):
                for col in 0 .. 4:
                    if len(players[idxPlayer].cols[col]) == 0:
                        if onWin(number, players[idxPlayer], user):
                            return
                        hasAlreadyWon.incl(idxPlayer)
            
proc part1Callback(number: int, player: PlayerState, user: var string): bool =
    user = $(sumUnmarked(player) * number)
    true

proc part2Callback(number: int, player: PlayerState, user: var Part2PlayState): bool =
    user.playersLeft -= 1
    if user.playersLeft == 0:
        user.result = $(sumUnmarked(player) * number)
        true
    else:
        false

func part1(numberDrawing: NumberDrawing, boards: openArray[Board]): string =
    play(numberDrawing, boards, part1Callback, result)
    
func part2(numberDrawing: NumberDrawing, boards: openArray[Board]): string =
    var state = Part2PlayState(playersLeft: len(boards))
    play(numberDrawing, boards, part2Callback, state)
    return state.result

when isMainModule:
    var
        f: File
        numberDrawing: NumberDrawing
        boards: seq[Board]
    let inputPath = if paramCount() > 0: paramStr(1) else: "day4.txt"
    if open(f, inputPath):
        if not readNumberDrawing(numberDrawing, f):
            echo("Couldn't read input file " & inputPath & "!")

        var board: Board
        while readBoard(board, f):
            boards.add(board)

        let res1 = part1(numberDrawing, boards)
        let res2 = part2(numberDrawing, boards)
        echo(%*{"output1": res1, "output2": res2})
    else:
        echo("Couldn't open input file " & inputPath & "!")