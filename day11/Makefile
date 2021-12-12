NIMC=nim c

all: day11.exe day11.dbg.exe

day11.dbg.exe: day11.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day11.dbg.exe day11.nim

day11.exe: day11.nim
	$(NIMC) --multimethods:on -d:release -o:day11.exe day11.nim

clean:
	rm -rf day11.dbg.exe day11.exe

.PHONY: clean
