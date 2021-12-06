NIMC=nim c

all: day6.exe day6.dbg.exe

day6.dbg.exe: day6.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day6.dbg.exe day6.nim

day6.exe: day6.nim
	$(NIMC) --multimethods:on -d:release -o:day6.exe day6.nim

clean:
	rm -rf day6.dbg.exe day6.exe

.PHONY: clean
