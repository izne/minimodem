# Makefile for minimodem Windows native build
# Target: TDM-GCC 64-bit (MinGW-style)
# Dependencies: libsndfile, fftw3f

# Compiler and flags
CC = gcc
CFLAGS = -Wall -O2
# Windows: use -D_WIN32_WINNT for Windows API version
CPPFLAGS = -D_WIN32_WINNT=0x0600

# Include paths - point to library include directories
INCLUDES = -I. -Isrc -I"Z:/fftw3-win" -I"Z:/libsndfile-1.2.2-win64/include"

# Library paths
LIBPATH = -L"Z:/fftw3-win" -L"Z:/libsndfile-1.2.2-win64/lib"

# Libraries
# Note: On Windows, library files are named lib<name>.a for linking
# The actual DLLs needed at runtime: libsndfile-1.dll, libfftw3f-3.dll
LIBS = $(LIBPATH) -lsndfile -lfftw3f-3 -lwinmm -lws2_32 -lm

# Output
TARGET = minimodem.exe

# Source files
SIMPLEAUDIO_SRC = \
	simpleaudio.c \
	simple-tone-generator.c \
	simpleaudio-pulse.c \
	simpleaudio-alsa.c \
	simpleaudio-sndio.c \
	simpleaudio-benchmark.c \
	simpleaudio-sndfile.c

FSK_SRC = fsk.c

BAUDOT_SRC = baudot.c

UIC_SRC = uic_codes.c

DATABITS_SRC = \
	databits_ascii.c \
	databits_binary.c \
	databits_callerid.c \
	databits_baudot.c \
	databits_uic.c

SOURCES = src/minimodem.c src/databits_ascii.c src/databits_binary.c src/databits_callerid.c src/databits_baudot.c src/databits_uic.c src/fsk.c src/baudot.c src/uic_codes.c src/simpleaudio.c src/simple-tone-generator.c src/simpleaudio-pulse.c src/simpleaudio-alsa.c src/simpleaudio-sndio.c src/simpleaudio-benchmark.c src/simpleaudio-sndfile.c

# Object files (strip src/ prefix for pattern matching)
OBJECTS = src/minimodem.o src/databits_ascii.o src/databits_binary.o src/databits_callerid.o src/databits_baudot.o src/databits_uic.o src/fsk.o src/baudot.o src/uic_codes.o src/simpleaudio.o src/simple-tone-generator.o src/simpleaudio-pulse.o src/simpleaudio-alsa.o src/simpleaudio-sndio.o src/simpleaudio-benchmark.o src/simpleaudio-sndfile.o

# Default target
all: $(TARGET)

# Link executable
$(TARGET): $(OBJECTS)
	$(CC) -o $@ $(OBJECTS) $(LIBS)

# Compile C files
src/%.o: src/%.c src/simpleaudio.h src/simpleaudio_internal.h src/fsk.h src/databits.h src/baudot.h src/uic_codes.h src/config.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) -DHAVE_CONFIG_H -c $< -o $@

# Clean build artifacts
clean:
	-@if exist src\*.o del /Q src\*.o
	-@if exist $(TARGET) del /Q $(TARGET)

# Phony targets
.PHONY: all clean

# Dependencies
minimodem.o: simpleaudio.h databits.h fsk.h baudot.h
baudot.o: baudot.h
databits_ascii.o: databits.h
databits_baudot.o: databits.h baudot.h
databits_callerid.o: databits.h
databits_uic.o: databits.h uic_codes.h
uic_codes.o: uic_codes.h
fsk.o: fsk.h
simpleaudio.o: simpleaudio.h simpleaudio_internal.h
simpleaudio-sndfile.o: simpleaudio.h simpleaudio_internal.h
simpleaudio-alsa.o: simpleaudio.h simpleaudio_internal.h
simpleaudio-pulse.o: simpleaudio.h simpleaudio_internal.h
simpleaudio-sndio.o: simpleaudio.h simpleaudio_internal.h
simpleaudio-benchmark.o: simpleaudio.h simpleaudio_internal.h
simple-tone-generator.o: simpleaudio.h