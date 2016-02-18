PREFIX = i686-w64-mingw32
CC = $(PREFIX)-gcc
TARGET = DynaCASE

all: $(TARGET).exe

$(TARGET).o: $(TARGET).c
	$(CC) -mwindows -c $<

$(TARGET).exe: $(TARGET).o icon.res
	$(CC) -o $@ $^

icon.rc: Pharo.ico
	echo 'id ICON $<' > $@

icon.res: icon.rc
	$(PREFIX)-windres $< -O coff -o $@

clean-all: clean
	rm -f $(TARGET).exe

clean:
	rm -f $(TARGET).o icon.rc icon.res

.PHONY: clean clean-all
