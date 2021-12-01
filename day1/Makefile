NIMC=nim c

all: day1.exe day1.dbg.exe

day1.dbg.exe: day1.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day1.dbg.exe day1.nim

day1.exe: day1.nim
	$(NIMC) --multimethods:on -d:release -o:day1.exe day1.nim

clean:
	rm -rf day1.dbg.exe day1.exe

.PHONY: clean
