import std/json
import std/sugar
import std/tables
import std/strutils
import std/sequtils
import std/os
import std/sets

type
    CaveKind = enum
        Start
        End
        Big
        Small
    Cave = object
        kind: CaveKind
    CaveSystem = object
        caves: Table[string, Cave]
        caveConnections: Table[string, seq[string]]
    Path = seq[string]
    PathConstraint = proc(cs: CaveSystem, path: Path): bool
    OnCompletePathCallback = proc (path: Path): void

func getCaveKind(caveId: string): CaveKind =
    if caveId == "start": return Start
    if caveId == "end": return End
    if caveId[0] in 'a'..'z': return Small
    if caveId[0] in 'A'..'Z': return Big

iterator connections(f: File): ((string, CaveKind), (string, CaveKind)) =
    for line in f.lines:
        let p = line.split('-')
        let c0 = p[0]
        let c1 = p[1]
        yield ((c0, getCaveKind(c0)), (c1, getCaveKind(c1)))

func connect(cs: var CaveSystem, c0: string, c1: string) =
    if c0 notin cs.caveConnections:
        cs.caveConnections[c0] = newSeq[string]()
    if c1 notin cs.caveConnections:
        cs.caveConnections[c1] = newSeq[string]()
    
    cs.caveConnections[c0].add(c1)
    cs.caveConnections[c1].add(c0)

proc readCaveSystem(f: File, cs: var CaveSystem): bool =
    for conn in f.connections:
        cs.caves[conn[0][0]] = Cave(kind: conn[0][1])
        cs.caves[conn[1][0]] = Cave(kind: conn[1][1])
        cs.connect(conn[0][0], conn[1][0])
    true

func smallCavesVisitedAtMostOnce(cs: CaveSystem, path: Path): bool =
    var visited: HashSet[string]

    for elem in path:
        let kind = cs.caves[elem].kind
        if kind == Small:
            if elem in visited:
                return false
            visited.incl(elem)
        
    return true

func smallCavesVisitedAtMostOnceWithASingleOneTwice(cs: CaveSystem, path: Path): bool =
    var visited: HashSet[string]
    var twiceVisit = false

    for elem in path:
        let kind = cs.caves[elem].kind
        if kind == Small:
            if elem in visited:
                if twiceVisit:
                    return false
                else:
                    twiceVisit = true
            visited.incl(elem)
        
    return true

func cursor(path: Path): string = path[high(path)]

func isPathComplete(path: Path): bool = path.cursor() == "end"

func expandPath(cs: CaveSystem, path: Path, C: PathConstraint, cb: OnCompletePathCallback) =
    for caveId in cs.caveConnections[path.cursor()]:
        if caveId == "start": continue
        var newPath = path
        newPath.add(caveId)
        if cs.C(newPath):
            if isPathComplete(newPath):
                cb(newPath)
            else:
                cs.expandPath(newPath, C, cb)

func paths(cs: CaveSystem, C: PathConstraint, cb: OnCompletePathCallback) =
    let initPath: Path = @["start"]
    cs.expandPath(initPath, C, cb)

func part1(cs: CaveSystem): string =
    var counter = 0
    cs.paths(smallCavesVisitedAtMostOnce, (p: Path) => ( counter += 1 ))
    $counter

func part2(cs: CaveSystem): string =
    var counter = 0
    cs.paths(smallCavesVisitedAtMostOnceWithASingleOneTwice, (p: Path) => ( counter += 1 ))
    $counter

when isMainModule:
    var
        f: File
        caveSystem: CaveSystem
    let inputPath = if paramCount() > 0: paramStr(1) else: "day12.txt"
    if open(f, inputPath):
        if not f.readCaveSystem(caveSystem):
            echo("Invalid input")
        let res1 = part1(caveSystem)
        let res2 = part2(caveSystem)
        echo(%*{"output1": res1, "output2": res2})

