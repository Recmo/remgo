SOURCES=$(shell cat sources | grep .cpp)
VERSION=$(shell git rev-parse --short HEAD)
CPP:=clang++ -Wall -O3 -g -std=c++0x -Wextra -Werror=return-type -Werror=switch -I. -DVERSION=L\"${VERSION}\"

remgo: $(patsubst %.cpp,%.o,$(SOURCES))
	$(CPP) $^ -lm -o $@

%.o: %.cpp
	$(CPP) -c $< -o $@

clean:
	rm -f $(patsubst %.cpp,%.o,$(SOURCES))

KGS=java -jar kgsGtp.jar
GNUGO=gnugo --mode gtp --chinese-rules --quiet
PACHI1=others/pachi.elf -d 0 -t =500 maximize_score
PACHI2=others/pachi.elf -d 0 -e random
PACHI3=others/pachi.elf -d 0 -e montecarlo -t =5000

test: remgo
	./twogtp.py --black '${GNUGO} --level=0' --white './remgo' --verbose 2
	#./twogtp.py --black '${PACHI3}' --white './remgo' --verbose 2


startBot: remgo
	${KGS} kgsGtp.config

stopBot: remgo
	killall -s SIGHUP remgo

updateServer: startServer.sh kgsGtp.jar kgsGtp.config remgo
	scp $^ 2pi:~/remgo
