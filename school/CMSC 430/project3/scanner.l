%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		("//"|"--").*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9])*
digit		[0-9]
int		{digit}+
real		{digit}+\.{digit}*([Ee][+-]?{digit}+)?
punc		[,:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"=="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSEQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEREQUAL; return(RELOP); }
"!="		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"**"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
rem		{ ECHO; yylval.oper = REMAINDER; return(REMOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
if		{ ECHO; return(IF); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
or		{ ECHO; return(OROP); }
not		{ ECHO; return(NOTOP); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
real		{ ECHO; return(REAL); }
others		{ ECHO; return(OTHERS); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
				strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
