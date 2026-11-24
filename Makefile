CC      = gcc
CFLAGS  = -Wall -O2
OBJS    = lexer.o parser.tab.o codegen.o main.o

all: nuvem-dsl

nuvem-dsl: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lexer.c: lexer.l parser.tab.h
	flex -o lexer.c lexer.l

lexer.o: lexer.c dsl.h parser.tab.h
	$(CC) $(CFLAGS) -c lexer.c -o lexer.o

parser.tab.o: parser.tab.c dsl.h
	$(CC) $(CFLAGS) -c parser.tab.c -o parser.tab.o

codegen.o: codegen.c dsl.h
	$(CC) $(CFLAGS) -c codegen.c -o codegen.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

clean:
	rm -f nuvem-dsl lexer.c parser.tab.c parser.tab.h *.o generated_wordcloud.py

.PHONY: all clean
