#include "rasklauncher.h"
#include "rasktheme.h"
#include "singleton.h"
#include "screenmanager.h"

#include <algorithm>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include "utilsJni.h"
#include <QAndroidJniEnvironment>
#endif

#ifdef Q_OS_ANDROID

static void nativeSystemTheme(JNIEnv */*env*/, jobject /*obj*/, jint theme)
{
    qDebug() << "System theme" << theme;
    emit Singleton<RaskTheme>::getInstanceQML().setSystemTheme(static_cast<RaskTheme::Theme>(theme));
}

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
#endif
{
    registerNativeMethods();
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

        listApplications << QVariantMap({ { "name", name }, { "packageName", package }, { "visible", true }, { "adaptativeIcon", iconType == QStringLiteral("Adaptative") } });
    }
#else
    listApplications << QVariantMap({ { "name", "0ad" }, { "packageName", "0ad" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Microsoft Office Excel" }, { "packageName", "ms-excel" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Microsoft Office" }, { "packageName", "ms-office" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Microsoft Office One Note" }, { "packageName", "ms-onenote" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Microsoft Office Outlook" }, { "packageName", "ms-outlook" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Adobe After Effects" }, { "packageName", "AdobeAfterEffect" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Adobe Photoshop" }, { "packageName", "AdobePhotoshop" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Android Studio" }, { "packageName", "android-studio" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Anatine" }, { "packageName", "anatine" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Anjuta" }, { "packageName", "anjuta" }, { "visible", true }, { "adaptativeIcon", true } });
    listApplications << QVariantMap({ { "name", "Calligra" }, { "packageName", "calligrastage" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "CPU AMD" }, { "packageName", "cpu-amd" }, { "visible", true }, { "adaptativeIcon", true } });
    listApplications << QVariantMap({ { "name", "CPU Info" }, { "packageName", "cpuinfo" }, { "visible", true }, { "adaptativeIcon", true } });
    listApplications << QVariantMap({ { "name", "Display" }, { "packageName", "display" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Finder" }, { "packageName", "file-manager" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Geany" }, { "packageName", "geany" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Gnome Books" }, { "packageName", "gnome-books" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Libre Office Calc" }, { "packageName", "libreoffice-calc" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Libre Office Draw" }, { "packageName", "libreoffice-draw" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Luminance HDR" }, { "packageName", "luminance-hdr" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Message" }, { "packageName", "message" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Minitube" }, { "packageName", "minitube" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "mongodb Compass" }, { "packageName", "mongodb-compass" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "pgadmin3" }, { "packageName", "pgadmin3" }, { "visible", true }, { "adaptativeIcon", true } });
    listApplications << QVariantMap({ { "name", "PCSXR" }, { "packageName", "pcsxr" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Pitivi" }, { "packageName", "pitivi" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Plasma" }, { "packageName", "plasma" }, { "visible", true }, { "adaptativeIcon", true } });
    listApplications << QVariantMap({ { "name", "Postman" }, { "packageName", "postman" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Preferences System Privacy" }, { "packageName", "preferences-system-privacy" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Preferences Tweaks" }, { "packageName", "preferences-tweaks-anim" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "qTransmission" }, { "packageName", "qtransmission" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Microsoft Office PowerPoint" }, { "packageName", "ms-powerpoint" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Microsoft Office Word" }, { "packageName", "ms-word" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Adobe Acrobat Reader" }, { "packageName", "acroread" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Chromium" }, { "packageName", "chromium-browser" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Firefox" }, { "packageName", "firefox" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Kodi" }, { "packageName", "kodi" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Libre Office Writer" }, { "packageName", "libreoffice-writer" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Okular" }, { "packageName", "okular" }, { "visible", true }, { "adaptativeIcon", false } });
    listApplications << QVariantMap({ { "name", "Opera" }, { "packageName", "opera" }, { "visible", true }, { "adaptativeIcon", true } });
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
                                  { "adaptativeIcon", true }
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
        { "systemTheme", "(I)V", reinterpret_cast<void *>(nativeSystemTheme) },
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

void RaskLauncher::getSystemResources()
{
    qDebug() << "Get system resources";
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher", "identifySystemTheme", "()V");
    Singleton<ScreenManager>::getInstanceQML().updateScreenValues();
#endif
}
