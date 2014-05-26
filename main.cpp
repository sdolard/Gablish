#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("sdolard");
    app.setOrganizationDomain("sdolard.com");
    app.setApplicationName("Gablish");
    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
