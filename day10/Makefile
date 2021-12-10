NIMC=nim c

all: day10.exe day10.dbg.exe

day10.dbg.exe: day10.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day10.dbg.exe day10.nim

day10.exe: day10.nim
	$(NIMC) --multimethods:on -d:release -o:day10.exe day10.nim

clean:
	rm -rf day10.dbg.exe day10.exe

.PHONY: clean
