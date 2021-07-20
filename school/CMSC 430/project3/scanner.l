%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws			[ \t\r]+
comment 	("//"|"--").*\n
line 		[\n]
id 			[A-Za-z](_?[A-Za-z0-9])*
digit 		[0-9]
int 		{digit}+
real 		{digit}+\.{digit}*([Ee][+-]?{digit}+)?
punc 		[,:;]
%%

{ws} 		{ ECHO; }
{comment} 	{ ECHO; nextLine(); }
{line} 		{ ECHO; nextLine();}
"<" 		{ ECHO; return(RELOP); }
"<=" 		{ ECHO; return(RELOP); }
"=" 		{ ECHO; return(RELOP); }
"/=" 		{ ECHO; return(RELOP); }
">" 		{ ECHO; return(RELOP); }
">=" 		{ ECHO; return(RELOP); }
"+" 		{ ECHO; return(ADDOP); }
"-" 		{ ECHO; return(ADDOP); }
"*" 		{ ECHO; return(MULOP); }
"/" 		{ ECHO; return(MULOP); }
"**" 		{ ECHO; return(EXPOP); }
"=>" 		{ ECHO; return(ARROW); }
begin 		{ ECHO; return(BEGIN_); }
boolean 	{ ECHO; return(BOOLEAN); }
case 		{ ECHO; return(CASE); }
else 		{ ECHO; return(ELSE); }
end 		{ ECHO; return(END); }
endcase 	{ ECHO; return(ENDCASE); }
endif 		{ ECHO; return(ENDIF); }
endreduce 	{ ECHO; return(ENDREDUCE); }
function 	{ ECHO; return(FUNCTION); }
if 			{ ECHO; return(IF); }
integer 	{ ECHO; return(INTEGER); }
is 			{ ECHO; return(IS); }
others 		{ ECHO; return(OTHERS); }
real 		{ ECHO; return(REAL); }
rem 		{ ECHO; return(REMOP); }
reduce 		{ ECHO; return REDUCE; }
returns 	{ ECHO; return(RETURNS); }
then 		{ ECHO; return(THEN); }
when 		{ ECHO; return(WHEN); }
or 			{ ECHO; return(OROP); }
and 		{ ECHO; return(ANDOP); }
not 		{ ECHO; return(NOTOP); }
false 		{ ECHO; return(BOOL_LITERAL); }
true 		{ ECHO; return(BOOL_LITERAL); }
{id} 		{ ECHO; return(IDENTIFIER);}
{int} 		{ ECHO; return(INT_LITERAL); }
{real} 		{ ECHO; return(REAL_LITERAL); }
{punc} 		{ ECHO; return(yytext[0]); }
. 			{ ECHO; appendError(LEXICAL, yytext); }
%%
