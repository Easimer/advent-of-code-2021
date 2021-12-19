NIMC=nim c

all: day13.exe day13.dbg.exe

day13.dbg.exe: day13.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day13.dbg.exe day13.nim

day13.exe: day13.nim
	$(NIMC) --multimethods:on -d:release -o:day13.exe day13.nim

clean:
	rm -rf day13.dbg.exe day13.exe

.PHONY: clean
