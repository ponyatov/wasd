# GUI subsystem

## hpp

```Cpp
#include <QApplication>
#include <QMainWindow>
#include <QPalette>

/// @name GUI

extern void gui();         /// ( -- ) start GUI

class MainWindow : public QMainWindow {
		QPalette dark;
	public:
		MainWindow(QString title);
};

extern QApplication *app;
extern MainWindow   *win;
```

## cpp

```Cpp
void gui() {
	win = new MainWindow("app"); win->show();
	app->exec();
}

MainWindow::MainWindow(QString title) : QMainWindow(nullptr) {
	dark.setColor(QPalette::Window, QColor(0x22, 0x22, 0x22));
	app->setPalette(dark);
}

QApplication *app = nullptr;
MainWindow   *win = nullptr;
```


[[Qt/tray]]