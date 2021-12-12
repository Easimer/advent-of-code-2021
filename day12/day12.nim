import std/json
import std/sugar
import std/tables
import std/strutils
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
    CaveID = int64
    CaveSystem = object
        caves: Table[CaveID, Cave]
        caveConnections: Table[CaveID, seq[CaveID]]
    Path = seq[CaveID]
    PathConstraint = proc(cs: CaveSystem, path: Path): bool
    OnCompletePathCallback = proc (path: Path): void

# Maps a cave ID string to a unique integer
func toCaveId(s: string): CaveID =
    result = 0
    for i in countdown(high(s), 0):
        # Map characters to
        # A-Z: 00-25
        # a-z: 26-50
        let c = s[i]
        let n = if c in 'A'..'Z':
            int(c) - 65
        else:
            int(c) - 97 + 26
        result = result * 51 + n

const CAVEID_START = toCaveId("start")
const CAVEID_END = toCaveId("end")

func getCaveKind(caveId: string): CaveKind =
    if caveId == "start": return Start
    if caveId == "end": return End
    if caveId[0] in 'a'..'z': return Small
    if caveId[0] in 'A'..'Z': return Big

iterator connections(f: File): ((CaveID, CaveKind), (CaveID, CaveKind)) =
    for line in f.lines:
        let p = line.split('-')
        let c0 = p[0]
        let c1 = p[1]
        yield ((c0.toCaveId(), getCaveKind(c0)), (c1.toCaveId(), getCaveKind(c1)))

func connect(cs: var CaveSystem, c0: CaveID, c1: CaveID) =
    if c0 notin cs.caveConnections:
        cs.caveConnections[c0] = newSeq[CaveID]()
    if c1 notin cs.caveConnections:
        cs.caveConnections[c1] = newSeq[CaveID]()
    
    cs.caveConnections[c0].add(c1)
    cs.caveConnections[c1].add(c0)

proc readCaveSystem(f: File, cs: var CaveSystem): bool =
    for conn in f.connections:
        cs.caves[conn[0][0]] = Cave(kind: conn[0][1])
        cs.caves[conn[1][0]] = Cave(kind: conn[1][1])
        cs.connect(conn[0][0], conn[1][0])
    true

func smallCavesVisitedAtMostOnce(cs: CaveSystem, path: Path): bool =
    var visited: HashSet[CaveID]

    for elem in path:
        let kind = cs.caves[elem].kind
        if kind == Small:
            if elem in visited:
                return false
            visited.incl(elem)
        
    return true

func smallCavesVisitedAtMostOnceWithASingleOneTwice(cs: CaveSystem, path: Path): bool =
    var visited: HashSet[CaveID]
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

func cursor(path: Path): CaveID = path[high(path)]

func isPathComplete(path: Path): bool = path.cursor() == CAVEID_END

func expandPath(cs: CaveSystem, path: var Path, C: PathConstraint, cb: OnCompletePathCallback) =
    for caveId in cs.caveConnections[path.cursor()]:
        if caveId == CAVEID_START: continue
        path.add(caveId)
        if cs.C(path):
            if isPathComplete(path):
                cb(path)
            else:
                cs.expandPath(path, C, cb)
        discard path.pop()

func paths(cs: CaveSystem, C: PathConstraint, cb: OnCompletePathCallback) =
    var initPath: Path = @[CAVEID_START]
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

