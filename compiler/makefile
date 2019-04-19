# Plutôt :
# gcc -o compiler y.tab.c lex.yy.c source/sym_table.c -ly -ll
compiler: y.tab.c lex.yy.c
	gcc -o compiler y.tab.c lex.yy.c source/sym_table.c source/assem_table.c -ly -ll

lex.yy.c: source/analyseur_lexical
	flex source/analyseur_lexical

y.tab.c: source/compiler.y
	yacc -d -v -t source/compiler.y

test: compiler
	./compiler < Brieuc_qui_fait_des_tests/while.c

clean:
	rm lex.yy.c y.tab.c y.tab.h
