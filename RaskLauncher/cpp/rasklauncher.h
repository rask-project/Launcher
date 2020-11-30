#pragma once

#include <QObject>
#include <QVariantList>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

class RaskLauncher : public QObject
{
    Q_PROPERTY(QVariantList applications READ applications NOTIFY applicationsChanged)
    Q_OBJECT
public:
    explicit RaskLauncher(QObject *parent = nullptr);

    QVariantList applications();

public slots:
    void retrievePackages();
    void launchApplication(const QString &application);
    bool isLaunchableApplication(const QString &application);
    void registerMethods();

signals:
    void applicationsChanged();

private:
    QVariantList m_applications;

#ifdef Q_OS_ANDROID
    QAndroidJniObject m_activity;
    QAndroidJniObject m_intentFilter;
//    QAndroidJniObject m_broadcastReceiver;
#endif

    void registerNativeMethods();
};

