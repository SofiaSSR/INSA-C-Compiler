LEX_SRC=timysofia-v2.l
YACC_SRC=timysofia-v3.y
CC=gcc

CFLAGS=-Wall -g
HFLAGS=-dy

BIN=compiler

# $(BIN): lex.yy.c
# 	$(CC) $(CFLAGS) lex.yy.c -o $(BIN)
$(BIN): y.tab.c
	$(CC) $(CFLAGS) y.tab.c -o $(BIN)

lex.yy.c: $(LEX_SRC)
	lex $(LEX_SRC)

yacc:  $(YACC_SRC)
	yacc $(YACC_SRC)
	flex $(LEX_SRC)
	bison $(HFLAGS) $(YACC_SRC)

clean:
	rm -rf ake testlex.yy.c $(BIN)

test: $(BIN)
	./$(BIN) < sample.c
	