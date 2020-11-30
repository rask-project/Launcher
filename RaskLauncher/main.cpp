#include <QGuiApplication>
#include <QQuickView>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlContext>

#include "cpp/rasklauncher.h"
#include "cpp/imageprovider.h"

static QObject *raskLauncher(QQmlEngine */*engine*/, QJSEngine */*scriptEngine*/)
{
    return new RaskLauncher;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName(QStringLiteral("Qt Rask"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("qtrask.com"));
    QCoreApplication::setApplicationName(QStringLiteral("Rask Launcher"));

    QQmlApplicationEngine engine;

    qmlRegisterSingletonType<RaskLauncher>("QtRask.Launcher", 1, 0, "RaskLauncher", raskLauncher);

    engine.addImageProvider(QLatin1String("systemImage"), new ImageProvider());

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if ((obj == nullptr) && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}
