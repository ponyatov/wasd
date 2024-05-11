# Проект [[qmake]]

Используемые части [[Qt]] (библиотека очень большая, поэтому её поделили на части, и для ускорения компиляции не включайте то чем не пользуетесь):

```Makefile
QT += core widgets
```
 
основной [[C++]] код

```Makefile
SOURCES += src/WASD.cpp
HEADERS += inc/WASD.hpp
```

код генерируется из файлов `.lex`/`.yacc`

```Makefile
SOURCES += tmp/WASD.*.cpp
HEADERS += tmp/WASD.*.hpp
```

указываются каталоги, в которых могут быть заголовочные файлы `.hpp`:

```Makefile
INCLUDEPATH += src
INCLUDEPATH += inc
INCLUDEPATH += tmp
```

все временые файлы напрвляем в каталог `/tmp` проекта:

```Makefile
DESTDIR     = bin
OBJECTS_DIR = tmp
MOC_DIR     = tmp
```

собираем в отладочном режиме, и с фишками свежего [[C++]]

```Makefile
CONFIG         += debug
CONFIG         += c++17
QMAKE_CXXFLAGS += -O0 -g2 -std=c++17
```

при компиляции парсера вываливаются ненужные сообщения с предупреждениями,
отключаем:

```Makefile
QMAKE_CXXFLAGS += -Wno-unused-function
QMAKE_CXXFLAGS += -Wno-unused-parameter
```

будем использовать пару библиотек, которые не относятся к набору [[Qt]] 

```Makefi)e
LIBS += -lreadline -lpmem
```

- [[readline]]
- [[pmem]]

[[Генерация WASD.mk для make]]