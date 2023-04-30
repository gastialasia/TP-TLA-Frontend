%{

#include "bison-actions.h"

%}

// Tipos de dato utilizados en las variables semánticas ($$, $1, $2, etc.).
%union {
	// No-terminales (backend).
	/*
	Program program;
	Expression expression;
	InnerExp innerExp;
	Constant constant;
	...
	*/

	// No-terminales (frontend).
	int program;
	int expression;
	int innerExp;
	int constant2;
	int integer;
	int biostype;
	int netExp;


	// Terminales.
	token token;
	int str;
}

// IDs y tipos de los tokens terminales generados desde Flex.
%token <token> OPEN_BRACKETS
%token <token> CLOSE_BRACKETS

%token <integer> STRING
%token <integer> INTEGER

%token <integer> CREATE
%token <integer> NAME CORES RAM DISK ISO BIOS
%token <integer> GB
%token <integer> UEFI LEGACY
%token <integer> NET TYPE MAC


// Tipos de dato para los no-terminales generados desde Bison.
%type <program> program
%type <expression> expression
%type <innerExp> innerExp
%type <constant2> constant2
%type <biostype> biostype
%type <netExp> netExp

// Reglas de asociatividad y precedencia (de menor a mayor).


// El símbolo inicial de la gramatica.
%start program

%%

program: constant2 expression													{ $$ = ProgramGrammarAction($2); }
	;

expression: CREATE OPEN_BRACKETS innerExp CLOSE_BRACKETS						{ $$ = InnerExpressionGrammarAction($3); }
	;

innerExp: NAME constant2 CORES INTEGER RAM INTEGER GB DISK INTEGER GB ISO constant2 BIOS biostype NET netExp { $$ = NameGrammarAction($2); }
	;	

constant2: STRING													{ $$ = StringConstantGrammarAction($1); }
	;

biostype: UEFI | LEGACY												{ $$ = StringConstantGrammarAction($1); }
	;

netExp: OPEN_BRACKETS TYPE constant2 MAC constant2 CLOSE_BRACKETS				{ $$ = StringConstantGrammarAction($3); }
	;

%%
