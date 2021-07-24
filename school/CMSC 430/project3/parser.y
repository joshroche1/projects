%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result;
int cases[50][2];
int arrptr = 0;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	int value;
	int arr[50][2];
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP

%token ARROW BEGIN_ BOOLEAN CASE ELSE END ENDCASE ENDIF ENDREDUCE FUNCTION 
%token INTEGER IF IS NOT OTHERS REAL REDUCE RETURNS THEN WHEN

%type <value> body statement_ statement reductions expression relation term
	factor primary term_ primary_
%type <oper> operator
%type <arr> cases case

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' ;

optional_variable:
	optional_variable variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

parameters:
	parameters ',' parameter |
	parameter ;

parameter:
	IDENTIFIER ':' type |
	;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement_ ';' statement |
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement ELSE statement ENDIF ';'
		{$$ = evaluateIf($2, $4, $6);} |
	CASE expression IS case OTHERS ARROW statement ';' ENDCASE 
		{$$ = evaluateCase($2, cases, $7);};

case:
	case when |
	when ;

when: 
	WHEN INT_LITERAL ARROW statement ';' {
		cases[arrptr][0] = $2;
		cases[arrptr][1] = $4;
		arrptr++;} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression ANDOP relation {$$ = $1 && $3;} |
	expression OROP relation {$$ = $1 || $3;} |
	expression NOTOP relation {$$ = !($1 && $3);} |
	relation ;

relation:
	relation RELOP term_ {$$ = evaluateRelational($1, $2, $3);} |
	IDENTIFIER '=' term_ {symbols.insert($1, $3);} | 
	term_ ;

term_:
	term_ REMOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP primary_ {$$ = evaluateArithmetic($1, $2, $3);} |
	primary_ ;

primary_:
	primary_ EXPOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
