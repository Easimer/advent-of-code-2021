NIMC=nim c

all: day12.exe day12.dbg.exe

day12.dbg.exe: day12.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day12.dbg.exe day12.nim

day12.exe: day12.nim
	$(NIMC) --multimethods:on -d:release -o:day12.exe day12.nim

clean:
	rm -rf day12.dbg.exe day12.exe

.PHONY: clean
