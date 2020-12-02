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
    void openApplicationDetailsSettings(const QString &application);
    void uninstallApplication(const QString &application);

    void registerMethods();
    void newApplication(const QString &packageName);
    void removedApplication(const QString &packageName);

signals:
    void applicationsChanged();

private slots:

private:
    QVariantList m_applications;

#ifdef Q_OS_ANDROID
    QAndroidJniObject m_activityLauncher;
    QAndroidJniObject m_intentFilter;
    QAndroidJniObject m_activityBroadcastReceiver;
    QAndroidJniObject m_intentFilterBroadcastReceiver;
    QAndroidJniObject m_broadcastReceiver;
#endif

    void registerNativeMethods();
    void registerBroadcastMethods();
};

