NIMC=nim c

all: day3.exe day3.dbg.exe

day3.dbg.exe: day3.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day3.dbg.exe day3.nim

day3.exe: day3.nim
	$(NIMC) --multimethods:on -d:release -o:day3.exe day3.nim

clean:
	rm -rf day3.dbg.exe day3.exe

.PHONY: clean
