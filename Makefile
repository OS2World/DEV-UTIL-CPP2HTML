FLAVOR =

CC = gcc
CFLAGS = -g $(FLAVOR) -L .
LEX = flex
# If you on SYSV uncomment the following line 
LIBS = -lfl
# If you have no libfl.a library supplied with flex , use libl.a
#LIBS = -ll

.PHONY: all C_PLUSPLUS ANSI_C USE_NAME

all:	cpp2html

C_PLUSPLUS:
	make cpp2latex FLAVOR=-DC_PLUSPLUS

ANSI_C:
	make c2latex FLAVOR=-DANSI_C

USE_NAME:
	make cpp2latex FLAVOR=-DUSE_NAME

c2latex.c: cpp2latex.c
	-ren cpp2latex.c c2latex.c

cpp2latex:	cpp2latex.o getopt1.o getopt.o version.o
	$(CC) $(CFLAGS) -o cpp2latex.exe cpp2latex.o getopt1.o getopt.o version.o $(LIBS)

c2latex:	c2latex.o getopt1.o getopt.o version.o
	$(CC) $(CFLAGS) -o c2latex.exe c2latex.o getopt1.o getopt.o version.o $(LIBS)

cpp2html.c : lex.yy.c 
	-ren lexyy.c cpp2html.c

lex.yy.c : cpp2html.l
	flex cpp2html.l
cpp2html : cpp2html.o getopt1.o getopt.o version.o
	$(CC) $(CFLAGS) -o cpp2html.exe cpp2html.o getopt1.o getopt.o version.o $(LIBS)

clean:
	-del *.o *.exe c2latex.c cpp2html.c cpp2latex.c


