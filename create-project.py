import os
import sys

if len(sys.argv) < 2:
    print('Usage: {} name'.format(sys.argv[0]))
    exit(1)

name = sys.argv[1]
root = './{}/'.format(name)

if os.path.exists(root):
    print('Already exists')
    exit(1)
os.mkdir(root)


def makeFile(fmt):
    with open(root + fmt.format(name), 'wb') as f:
        pass


makeFile('{}.nim')
makeFile('{}.txt')
with open(root + 'output.txt', 'wb') as f:
    pass

with open(root + 'Makefile', 'w') as f:
    f.write('NIMC=nim c\n\n')
    f.write('all: {0}.exe {0}.dbg.exe\n\n'.format(name))
    f.write('{0}.dbg.exe: {0}.nim\n'.format(name))
    f.write(
        '\t$(NIMC) --multimethods:on --debugger:native --checks:on --assertions:on -o:{0}.dbg.exe {0}.nim\n\n'.format(name))
    f.write('{0}.exe: {0}.nim\n'.format(name))
    f.write(
        '\t$(NIMC) --multimethods:on -d:release -o:{0}.exe {0}.nim\n\n'.format(name))
    f.write('clean:\n\trm -rf {0}.dbg.exe {0}.exe\n\n'.format(name))
    f.write('.PHONY: clean\n')
