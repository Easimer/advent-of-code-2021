NIMC=nim c

all: day8.exe day8.dbg.exe

day8.dbg.exe: day8.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day8.dbg.exe day8.nim

day8.exe: day8.nim
	$(NIMC) --multimethods:on -d:release -o:day8.exe day8.nim

clean:
	rm -rf day8.dbg.exe day8.exe

.PHONY: clean
