#include <QGuiApplication>
#include <QQuickView>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QIcon>
#include <memory>

#include "cpp/singleton.h"
#include "cpp/rasklauncher.h"
#include "cpp/imageprovider.h"
#include "cpp/androidvibrate.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName(QStringLiteral("Qt Rask"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("qtrask.com"));
    QCoreApplication::setApplicationName(QStringLiteral("Rask Launcher"));

    QQmlApplicationEngine engine;

    qmlRegisterSingletonType<RaskLauncher>("QtRask.Launcher", 1, 0, "RaskLauncher", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        return &Singleton<RaskLauncher>::getInstance(engine, scriptEngine);
    });

    qmlRegisterSingletonType<AndroidVibrate>("QtRask.Launcher", 1, 0, "AndroidVibrate", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        return &Singleton<AndroidVibrate>::getInstance(engine, scriptEngine);
    });

    std::unique_ptr<ImageProvider> imageProvider = std::make_unique<ImageProvider>();
    engine.addImageProvider(QStringLiteral("systemImage"), imageProvider.get());

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if ((obj == nullptr) && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    QIcon::setThemeSearchPaths({":/"});
    QIcon::setThemeName("material-round");

    engine.load(url);

    return QGuiApplication::exec();
}
