LEX_SRC=lex.l
YACC_SRC=yacc.y
CC=gcc

CFLAGS=-Wall -g
HFLAGS=-dy

BIN=compiler


$(BIN): y.tab.c
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -o $(BIN)


lex.yy.c: $(LEX_SRC)
	lex $(LEX_SRC)

y.tab.c:  $(YACC_SRC)
	yacc -d $(YACC_SRC)
	flex $(LEX_SRC)
	bison $(HFLAGS) $(YACC_SRC)


clean:
	rm -rf ake testlex.yy.c $(BIN)

test: $(BIN)
	./$(BIN) < sample.c
	