NIMC=nim c

all: day7.exe day7.dbg.exe

day7.dbg.exe: day7.nim
	$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:day7.dbg.exe day7.nim

day7.exe: day7.nim
	$(NIMC) --multimethods:on -d:release -o:day7.exe day7.nim

clean:
	rm -rf day7.dbg.exe day7.exe

.PHONY: clean
