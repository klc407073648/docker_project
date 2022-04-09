# target
TARGET	= catcpp
# compiler
CXX    	= /usr/local/bin/g++
LIBS	= -L../libs/ -Wl,-Bdynamic -lrt -lcatclient
CXXFLAGS= -g -std=c++11  -Wall -rdynamic -ldl

CPPFLAGS= -I.  -I../include -I../include/cat

SRC	= $(wildcard *.cpp)
OBJ	= $(patsubst %.cpp,%.o,$(SRC) )

# all:$(OBJ) $(TARGET)

$(TARGET):$(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(LIBS)
clean:
	rm -rf $(TARGET) *.o