NIMC=nim c

all: day4.exe day4.dbg.exe

day4.dbg.exe: day4.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day4.dbg.exe day4.nim

day4.exe: day4.nim
	$(NIMC) --multimethods:on -d:release -o:day4.exe day4.nim

clean:
	rm -rf day4.dbg.exe day4.exe

.PHONY: clean
