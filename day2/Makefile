NIMC=nim c

all: day2.exe day2.dbg.exe

day2.dbg.exe: day2.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day2.dbg.exe day2.nim

day2.exe: day2.nim
	$(NIMC) --multimethods:on -d:release -o:day2.exe day2.nim

clean:
	rm -rf day2.dbg.exe day2.exe

.PHONY: clean
