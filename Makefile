CPP:=g++-4.6 -Wall -O2 -g -std=c++0x -lm -DLOCAL -march=nocona -Wextra -Werror=return-type -Werror=switch -I.


SOURCES=$(shell cat sources | grep .cpp)

entry: $(patsubst %.cpp,%.o,$(SOURCES))
	$(CPP) $^ -o $@

%.o: %.cpp
	$(CPP) -c $< -o $@

monolith: monolith.cpp
	$(CPP) monolith.cpp -o monolith

heuristic: monolith.cpp
	$(CPP) -DHEURISTIC monolith.cpp -o heuristic

monolith.cpp: sources $(shell cat sources)
	cat `cat sources` > monolith.cpp
	sed -i "s|^#pragma once$$||g" monolith.cpp
	sed -i "s|^#include \".*$$||g" monolith.cpp


competition: monolith heuristic
	cd caia/ayu/bin; ./competition.sh d930825 d17a66e 2313bcc 2313bccheuristic monolith5 monolith 390939f
	#cd caia/ayu/bin; ./competition.sh random 2313bcc monolith
	@if grep -R disqualified caia/ayu/refereelogs; \
	then echo There where errors; \
	else echo There where no errors; \
	fi

clean:
	rm *.o

clean-comp:
	rm caia/ayu/*logs*/* caia/ayu/competition-*/*

