D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

err         .

%option noyywrap

%{
#include <stdio.h>
#include "infixcal.tab.h"

int getREGID(char*);

%}

%%

[ \t]           ; // ignore all whitespace
{D}+            { yylval = atoi(yytext); return NUM;}
{H}+h           { yylval = (int)strtol(yytext, NULL, 16); return NUM;}
[+]             { return T_PLUS;}
[-]             { return T_MINUS;}
[*]             { return T_MUL;}
[/]             { return T_DIV;}
"^"             { return T_POW;}
"("             { return LEFT_PAREN;}
")"             { return RIGHT_PAREN;}
\n				{ return T_ENDL;}
AND             { return T_AND;}
OR              { return T_OR;}
NOT             { return T_NOT;}
"\\"            { return T_MOD;}
$r[A-Z]         { yylval = (int)getREGID(yytext);return T_REG;}       
$acc            { return T_ACC;}       
SHOW            { return T_SHOW;}
PUSH            { return T_PUSH;}
POP             { return T_POP;}
$top            { return T_TOP;}
$size           { return T_SIZE;}
LOAD            { return T_LOAD;}
END             { return T_EXIT;}

{err}           { return T_ERR;}


%%

int getREGID(char* yytext)
{
    return yytext[2]-'A';
}
