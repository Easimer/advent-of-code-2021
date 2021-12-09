NIMC=nim c

all: day9.exe day9.dbg.exe

day9.dbg.exe: day9.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day9.dbg.exe day9.nim

day9.exe: day9.nim
	$(NIMC) --multimethods:on -d:release -o:day9.exe day9.nim

clean:
	rm -rf day9.dbg.exe day9.exe

.PHONY: clean
