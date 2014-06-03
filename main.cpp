#include <QApplication>
#include <QQmlApplicationEngine>
#include "gabrecorder.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("sdolard");
    app.setOrganizationDomain("sdolard.com");
    app.setApplicationName("Gablish");

    QQmlApplicationEngine engine;

    qmlRegisterType<GabRecorder>("gablish.gabrecorder", 1, 0, "GabRecorder");

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
