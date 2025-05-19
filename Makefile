LEX_SRC=lex.l
YACC_SRC=yacc.y
CC=gcc

CFLAGS=-Wall -g
HFLAGS=-dy

BIN=compiler

OBJ=y.tab.o lex.yy.o

new: clean $(BIN)

all: $(BIN)

lex.yy.c: $(LEX_SRC)
	lex $(LEX_SRC)

y.tab.c:  $(YACC_SRC)
	yacc -v -g -t -d $<

$(BIN): $(OBJ) 
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm $(OBJ) y.tab.c y.tab.h lex.yy.c

	