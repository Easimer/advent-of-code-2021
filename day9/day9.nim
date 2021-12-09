import strutils
import os
import json
import options
import std/sets
import std/algorithm

type
    Coord = (int, int)
    HeightMap = object
        width, height: int
        data: seq[uint8]
    
    LowPointMap = object
        width, height: int
        data: seq[uint8]

    Basin = object
        middle: HashSet[Coord]
        frontier: HashSet[Coord]

iterator coords[T](map: T): Coord =
    for y in 0 .. map.height - 1:
        for x in 0 .. map.width - 1:
            yield (x, y)

proc readHeightmap(f: File, map: var HeightMap): bool =
    var line: string
    var height = 0
    var width = 0
    while f.readLine(line):
        width = len(line)
        height += 1
        for ch in line:
            map.data.add(uint8(parseInt($ch)))
    map.width = width
    map.height = height
    true

func sampleBorder(map: HeightMap, c: Coord): int =
    let x = c[0]
    let y = c[1]
    if x < 0 or x >= map.width or y < 0 or y >= map.height:
        return 16
    int(map.data[y * map.width + x])

func sampleBorder(map: LowPointMap, c: Coord): uint8 =
    let x = c[0]
    let y = c[1]
    if x < 0 or x >= map.width or y < 0 or y >= map.height:
        return uint8(0)
    map.data[y * map.width + x]

iterator neighbors(coord: Coord): Coord =
    yield (coord[0], coord[1] - 1)
    yield (coord[0], coord[1] + 1)
    yield (coord[0] - 1, coord[1])
    yield (coord[0] + 1, coord[1])

func lowPointMap(map: HeightMap): LowPointMap =
    result.width = map.width
    result.height = map.height
    for C in map.coords:
        let center = map.sampleBorder(C)
        var lpme = uint8(1)
        for neighbor in C.neighbors:
            let n = map.sampleBorder(neighbor)
            if n <= center:
                lpme = 0
                break
        result.data.add(lpme)

func riskLevel(map: HeightMap, c: Coord): int =
    int(map.sampleBorder(c)) + 1

func growBasin(map: HeightMap, basin: var Basin): bool =
    var nextFrontier = initHashSet[Coord]()
    for frontierCoord in basin.frontier:
        let curLevel = map.sampleBorder(frontierCoord)
        for neighbor in frontierCoord.neighbors:
            # Skips cells already in the basin
            if neighbor in basin.middle:
                continue
            if neighbor in basin.frontier:
                continue
            let neighborLevel = map.sampleBorder(neighbor)
            if neighborLevel >= 9:
                continue
            if neighborLevel - curLevel >= 0:
                nextFrontier.incl(neighbor)
    basin.middle.incl(basin.frontier)
    basin.frontier = nextFrontier

    len(nextFrontier) != 0

func part1(map: HeightMap): string =
    var sum = 0
    let lowPointMap = map.lowPointMap()
    for C in map.coords:
        if lowPointMap.sampleBorder(C) == 1:
            let riskLevel = map.riskLevel(C)
            sum += riskLevel
    $sum

proc part2(map: HeightMap): string =
    var sizes = newSeq[int]()
    var basins = newSeq[Basin]()
    let lowPointMap = map.lowPointMap()
    for c in lowPointMap.coords:
        if 1 == lowPointMap.sampleBorder(c):
            var basin = Basin()
            basin.frontier.incl(c)
            while map.growBasin(basin):
                discard
            sizes.add(len(basin.middle))
            basins.add(basin)

    # each cell (except 9's) must be part of a basin
    for c in map.coords:
        let value = map.sampleBorder(c)
        var partofabasin = false
        for basin in basins:
            if c in basin.middle:
                partofabasin = true
                break
        
        assert(partofabasin or value == 9)
    
    sizes.sort(SortOrder.Descending)
    $(sizes[0] * sizes[1] * sizes[2])

when isMainModule:
    var
        f: File
        heightmap: HeightMap
    let inputPath = if paramCount() > 0: paramStr(1) else: "day9.txt"
    if open(f, inputPath):
        if not f.readHeightmap(heightmap):
            discard
        let res1 = part1(heightmap)
        let res2 = part2(heightmap)
        echo(%*{"output1": res1, "output2": res2})
