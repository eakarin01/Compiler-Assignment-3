all:
	bison -d infixcal.y
	flex infixcal.l
	gcc infixcal.tab.c lex.yy.c -lfl -lm -o infixcal
clean:
	rm infixcal.tab.c lex.yy.c infixcal.tab.h