#ifndef WASD_H_
#define WASD_H_

#include <QApplication>
#include <QDebug>

extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;
extern int yyparse();
extern void yyerror(QString msg);
#include "WASD.parser.hpp"

#endif  // WASD_H_
