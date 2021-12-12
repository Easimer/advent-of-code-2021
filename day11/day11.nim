import std/json
import std/os
import std/strutils
import std/sets

type
    Grid = array[10, array[10, int]]

proc readGrid(f: File, grid: var Grid): bool =
    var y = 0
    for line in f.lines:
        if len(line) != 10:
            return false
        for x in 0..9:
            grid[y][x] = parseInt($line[x])
        y += 1
    
    y == 10

iterator neighbors(c: (int, int)): (int, int) =
    for y in -1..1:
        for x in -1..1:
            if x == 0 and y == 0:
                continue
            let nx = c[0] + x
            if nx < 0 or nx > 9: continue
            let ny = c[1] + y
            if ny < 0 or ny > 9: continue
            yield (c[0] + x, c[1] + y)

func step(grid: var Grid): HashSet[(int, int)] =
    var flashing: HashSet[(int, int)]
    var flashed: HashSet[(int, int)]
    for y in 0..9:
        for x in 0..9:
            grid[y][x] += 1
            if grid[y][x] > 9:
                flashing.incl((x, y))
    
    while len(flashing) != 0:
        let C = flashing.pop()
        flashed.incl(C)
        for N in C.neighbors:
            let x = N[0]
            let y = N[1]
            grid[y][x] += 1
            if grid[y][x] > 9 and N notin flashed:
                flashing.incl(N)
    
    for C in flashed:
        grid[C[1]][C[0]] = 0
        
    flashed


func part1(grid: Grid): string =
    var totalFlashes = 0
    var G = grid
    for i in 0..99:
        let flashed = G.step()
        totalFlashes += len(flashed)

    $totalFlashes

func part2(grid: Grid): string =
    var G = grid
    var i = 1
    while true:
        let flashed = G.step()
        if len(flashed) == 100:
            return $i
        i += 1

when isMainModule:
    var
        f: File
        grid: Grid
    let inputPath = if paramCount() > 0: paramStr(1) else: "day11.txt"
    if open(f, inputPath):
        if not f.readGrid(grid):
            echo("Invalid input")
        let res1 = part1(grid)
        let res2 = part2(grid)
        echo(%*{"output1": res1, "output2": res2})
