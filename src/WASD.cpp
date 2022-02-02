#include "WASD.hpp"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    for (auto i = 1; i < argc; i++) {
        assert(yyin = fopen(argv[i], "r"));
        yyparse();
        fclose(yyin);
    }
    return 0;
    return app.exec();
}

#define YYERR "\n\n" << yylineno << ':' << msg << '[' << yytext << "]\n\n"
void yyerror(QString msg) {
    qDebug() << YYERR;
    exit(-1);
}
