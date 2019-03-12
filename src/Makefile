CFLAGS= -Wall -g
CC= gcc

CCFILES= symbol.c intermediate.c check.c type.c location.c array.c assembly.c optimise.c function.c
HHFILES= symbol.h intermediate.h check.h type.h location.h array.h assembly.h optimise.h function.h
SOURCE= Makefile $(CCFILES) $(HHFILES) tinyc.y lex.l

all: tinyc


# $@ = file name of the target of the rule
# $^ = names of all the prerequisites, with spaces between them
tinyc: tinyc.tab.o lex.yy.o $(CCFILES:%.c=%.o)
	gcc $(CFLAGS) -o $@ $^

lex.yy.c: lex.l tinyc.tab.h
	flex lex.l 




# Bison options:
#
# -v Generates tinyc.output, which shows the states of the LARL parser
# -d Generates tinyc.tab.h, which contains the token type definitions
tinyc.tab.h tinyc.tab.c: tinyc.y
	bison -v -d -t $^


clean:
	rm -f lex.yy.c tinyc.tab.[hc] *.o mct tinyc *.jasm *.class tinyc.output

tar:
	tar cvf tinyc.tar $(SOURCE)

source:
	@echo $(SOURCE)




