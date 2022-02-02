%{
    #include "WASD.hpp"
%}

%option noyywrap yylineno

%%
#[^\n]*     {                   }   // line comment
[ \t\r\n]+  {                   }   // drop spaces
.           { yyerror("lexer"); }   // any unknown char
