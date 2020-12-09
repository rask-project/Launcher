#include "rasklauncher.h"
#include "singleton.h"

#include <algorithm>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include "utilsJni.h"
#include <QAndroidJniEnvironment>
#endif

#ifdef Q_OS_ANDROID
static void nativeNewIntent(JNIEnv */*env*/, jobject /*obj*/)
{
    qDebug() << "New Intent";
}

static void nativePackageAdded(JNIEnv */*env*/, jobject /*obj*/, jstring packageName)
{
    qDebug() << "Emit package added" << packageName;
    Singleton<RaskLauncher>::getInstanceQML().newApplication(UtilsJni::jstringToQString(packageName));
}

static void nativePackageRemoved(JNIEnv */*env*/, jobject /*obj*/, jstring packageName)
{
    qDebug() << "Emit package removed" << UtilsJni::jstringToQString(packageName);
    Singleton<RaskLauncher>::getInstanceQML().removedApplication(UtilsJni::jstringToQString(packageName));
}
#endif

RaskLauncher::RaskLauncher(QObject *parent) :
    QObject(parent),
    applications(Singleton<Applications>::getInstanceQML())
#ifdef Q_OS_ANDROID
    , m_activityLauncher(QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;"))
    , m_intentFilter(QAndroidJniObject("android/content/IntentFilter"))
    , m_activityBroadcastReceiver(QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;"))
    , m_intentFilterBroadcastReceiver(QAndroidJniObject("android/content/IntentFilter"))
    , m_broadcastReceiver(QAndroidJniObject("com/QtRask/Launcher/PackageBroadcast"))
#endif
{
    registerNativeMethods();
    registerBroadcastMethods();
}

void RaskLauncher::retrievePackages()
{
    qDebug() << "Retrieve Packages";
    QVariantList listApplications{};

#ifdef Q_OS_ANDROID
    QAndroidJniObject getApplications = QAndroidJniObject::callStaticObjectMethod("com/QtRask/Launcher/RaskLauncher",
                                                                                  "getListApplications",
                                                                                  "()[Lcom/QtRask/Launcher/Application;");

    jobjectArray array = getApplications.object<jobjectArray>();

    QAndroidJniEnvironment env;
    jsize size = env->GetArrayLength(array);

    for (int i = 0; i < size; ++i)
    {
        QAndroidJniObject obj = env->GetObjectArrayElement(array, i);

        QString name = UtilsJni::jstringToQString((obj.callObjectMethod<jstring>("getName")).object<jstring>());
        QString package = UtilsJni::jstringToQString((obj.callObjectMethod<jstring>("getPackageName")).object<jstring>());
        QString iconType = UtilsJni::jstringToQString((obj.callObjectMethod<jstring>("getIconType")).object<jstring>());

        listApplications << QVariantMap({ { "name", name }, { "packageName", package }, { "iconAdaptative", iconType == QStringLiteral("Adaptative") } });
    }
#else
    listApplications << QVariantMap({ { "name", "0ad" }, { "packageName", "0ad" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Microsoft Office Excel" }, { "packageName", "ms-excel" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Microsoft Office" }, { "packageName", "ms-office" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Microsoft Office One Note" }, { "packageName", "ms-onenote" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Microsoft Office Outlook" }, { "packageName", "ms-outlook" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Adobe After Effects" }, { "packageName", "AdobeAfterEffect" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Adobe Photoshop" }, { "packageName", "AdobePhotoshop" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Android Studio" }, { "packageName", "android-studio" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Anatine" }, { "packageName", "anatine" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Anjuta" }, { "packageName", "anjuta" }, { "adaptativeIcon", 1 } });
    listApplications << QVariantMap({ { "name", "Calligra" }, { "packageName", "calligrastage" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "CPU AMD" }, { "packageName", "cpu-amd" }, { "adaptativeIcon", 1 } });
    listApplications << QVariantMap({ { "name", "CPU Info" }, { "packageName", "cpuinfo" }, { "adaptativeIcon", 1 } });
    listApplications << QVariantMap({ { "name", "Display" }, { "packageName", "display" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Finder" }, { "packageName", "file-manager" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Geany" }, { "packageName", "geany" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Gnome Books" }, { "packageName", "gnome-books" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Libre Office Calc" }, { "packageName", "libreoffice-calc" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Libre Office Draw" }, { "packageName", "libreoffice-draw" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Luminance HDR" }, { "packageName", "luminance-hdr" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Message" }, { "packageName", "message" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Minitube" }, { "packageName", "minitube" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "mongodb Compass" }, { "packageName", "mongodb-compass" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "pgadmin3" }, { "packageName", "pgadmin3" }, { "adaptativeIcon", 1 } });
    listApplications << QVariantMap({ { "name", "PCSXR" }, { "packageName", "pcsxr" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Pitivi" }, { "packageName", "pitivi" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Plasma" }, { "packageName", "plasma" }, { "adaptativeIcon", 1 } });
    listApplications << QVariantMap({ { "name", "Postman" }, { "packageName", "postman" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Preferences System Privacy" }, { "packageName", "preferences-system-privacy" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Preferences Tweaks" }, { "packageName", "preferences-tweaks-anim" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "qTransmission" }, { "packageName", "qtransmission" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Microsoft Office PowerPoint" }, { "packageName", "ms-powerpoint" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Microsoft Office Word" }, { "packageName", "ms-word" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Adobe Acrobat Reader" }, { "packageName", "acroread" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Chromium" }, { "packageName", "chromium-browser" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Firefox" }, { "packageName", "firefox" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Kodi" }, { "packageName", "kodi" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Libre Office Writer" }, { "packageName", "libreoffice-writer" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Okular" }, { "packageName", "okular" }, { "adaptativeIcon", 0 } });
    listApplications << QVariantMap({ { "name", "Opera" }, { "packageName", "opera" }, { "adaptativeIcon", 1 } });
#endif

    applications.addApplications(listApplications);
}

void RaskLauncher::newApplication(const QString &packageName)
{
    qDebug() << "New Application" << packageName;
    QVariantMap application;

#ifdef Q_OS_ANDROID
    QAndroidJniObject applicationJNI = QAndroidJniObject::callStaticObjectMethod("com/QtRask/Launcher/RaskLauncher",
                                                                              "getApplicationData",
                                                                              "(Ljava/lang/String;)Lcom/QtRask/Launcher/Application;",
                                                                              QAndroidJniObject::fromString(packageName).object<jstring>());

    QString name = UtilsJni::jstringToQString((applicationJNI.callObjectMethod<jstring>("getName")).object<jstring>());
    QString package = UtilsJni::jstringToQString((applicationJNI.callObjectMethod<jstring>("getPackageName")).object<jstring>());
    QString iconType = UtilsJni::jstringToQString((applicationJNI.callObjectMethod<jstring>("getIconType")).object<jstring>());

    qDebug() << "Added" << name << package << iconType;
    application = QVariantMap({
                                  { "name", name },
                                  { "packageName", package },
                                  { "adaptativeIcon", iconType }
                              });
#else
    application = QVariantMap({
                                  { "name", packageName },
                                  { "packageName", packageName },
                                  { "adaptativeIcon", 1 }
                              });
#endif
    applications.addApplication(application);
}

void RaskLauncher::removedApplication(const QString &packageName)
{
    applications.removeApplication(packageName);
}

void RaskLauncher::launchApplication(const QString &application)
{
    qDebug() << "Launch Application" << application;
#ifdef Q_OS_ANDROID
    qDebug() << "Launch Application" << application;
    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher",
                                              "launchApplication",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(application).object<jstring>());
#endif
}

void RaskLauncher::openApplicationDetailsSettings(const QString &application)
{
    qDebug() << "Launch Application Details Settings" << application;
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher",
                                              "applicationDetailsSettings",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(application).object<jstring>());
#endif
}

void RaskLauncher::uninstallApplication(const QString &application)
{
    qDebug() << "Uninstall Application" << application;
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher",
                                              "uninstallApplication",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(application).object<jstring>());
#else
    removedApplication(application);
#endif
}

void RaskLauncher::registerMethods()
{
    registerNativeMethods();
}

void RaskLauncher::registerNativeMethods()
{
#ifdef Q_OS_ANDROID
    qDebug() << "Register Native methods";
    JNINativeMethod methods[] {
        { "newIntent", "()V", reinterpret_cast<void *>(nativeNewIntent) },
        { "packageAdded", "(Ljava/lang/String;)V", reinterpret_cast<void *>(nativePackageAdded) },
        { "packageRemoved", "(Ljava/lang/String;)V", reinterpret_cast<void *>(nativePackageRemoved) }
    };

    QAndroidJniEnvironment env;
    jclass objectClass = env->GetObjectClass(m_activityLauncher.object<jobject>());
    if (env->ExceptionCheck())
        env->ExceptionClear();

    env->RegisterNatives(objectClass, methods, sizeof (methods) / sizeof (methods[0]));
    if (env->ExceptionCheck())
        env->ExceptionClear();

    env->DeleteLocalRef(objectClass);
    if (env->ExceptionCheck())
        env->ExceptionClear();
#endif
}

void RaskLauncher::registerBroadcastMethods()
{
#ifdef Q_OS_ANDROID
    qDebug() << "Register Broadcast methods";

    QAndroidJniObject addActionString = QAndroidJniObject::fromString("android.intent.action.PACKAGE_ADDED");
    QAndroidJniObject removeActionString = QAndroidJniObject::fromString("android.intent.action.PACKAGE_REMOVED");
    QAndroidJniObject dataSchemeString = QAndroidJniObject::fromString("package");

    m_intentFilterBroadcastReceiver.callMethod<void>("addAction", "(Ljava/lang/String;)V", addActionString.object<jstring>());
    m_intentFilterBroadcastReceiver.callMethod<void>("addAction", "(Ljava/lang/String;)V", removeActionString.object<jstring>());
    m_intentFilterBroadcastReceiver.callMethod<void>("addDataScheme", "(Ljava/lang/String;)V", dataSchemeString.object<jstring>());

    m_activityBroadcastReceiver.callObjectMethod("registerReceiver",
                                "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;",
                                m_broadcastReceiver.object<jobject>(),
                                m_intentFilterBroadcastReceiver.object<jobject>());
#endif
}
