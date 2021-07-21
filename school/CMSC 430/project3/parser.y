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

%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token <oper> ADDOP MULOP RELOP EXPOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN CASE ELSE END ENDCASE ENDIF ENDREDUCE FUNCTION IF INTEGER IS REDUCE RETURNS THEN WHEN 

%type <value> body statement_ statement reductions expression relation term case 
	factor primary
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER RETURNS type ';' ;

optional_variable:
	variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	IF '(' relation ')' THEN statement ELSE statement ENDIF ';' |
	CASE expression IS case OTHERS ARROW statement ';' ENDCASE ';' ;
	
	REDUCE operator reductions ENDREDUCE {$$ = $3;} ;

case:
	WHEN INT_LITERAL ARROW statement ;

operator:
	ADDOP |
	MULOP |
	EXPOP |
	;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression ANDOP relation {$$ = $1 && $3;} |
	expression NOTOP relation {$$ = $1 && $3;} |
	expression OROP relation {$$ = $1 && $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	factor EXPOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
