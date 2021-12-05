NIMC=nim c

all: day5.exe day5.dbg.exe

day5.dbg.exe: day5.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day5.dbg.exe day5.nim

day5.exe: day5.nim
	$(NIMC) --multimethods:on -d:release -o:day5.exe day5.nim

clean:
	rm -rf day5.dbg.exe day5.exe

.PHONY: clean
