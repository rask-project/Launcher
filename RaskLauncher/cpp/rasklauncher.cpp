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
    Singleton<RaskLauncher>::getInstance().newApplication(UtilsJni::jstringToQString(packageName));
}

static void nativePackageRemoved(JNIEnv */*env*/, jobject /*obj*/, jstring packageName)
{
    qDebug() << "Emit package removed" << packageName;
    Singleton<RaskLauncher>::getInstance().removedApplication(UtilsJni::jstringToQString(packageName));
}
#endif

RaskLauncher::RaskLauncher(QObject *parent) :
    QObject(parent)
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

        m_applications << QVariantMap({ { "name", name }, { "packageName", package }, { "adaptativeIcon", iconType == "Adaptative" } });
        qDebug() << "Application" << "name:" << name << "package:" << package;
    }
#else
    /*
    m_applications << QVariantMap({ { "name","Adobe Acrobat" }, { "packageName", "com.adobe.reader" } });
    m_applications << QVariantMap({ { "name","Agenda" }, { "packageName", "com.google.android.calendar" } });
    m_applications << QVariantMap({ { "name","AliExpress" }, { "packageName", "com.alibaba.aliexpresshd" } });
    m_applications << QVariantMap({ { "name","Anotações" }, { "packageName", "com.miui.notes" } });
    m_applications << QVariantMap({ { "name","Assistente" }, { "packageName", "com.google.android.apps.googleassistant" } });
    m_applications << QVariantMap({ { "name","Bradesco" }, { "packageName", "com.bradesco" } });
    m_applications << QVariantMap({ { "name","Bússola" }, { "packageName", "com.miui.compass" } });
    m_applications << QVariantMap({ { "name","CAIXA Tem" }, { "packageName", "br.gov.caixa.tem" } });
    m_applications << QVariantMap({ { "name","Calculadora Mi" }, { "packageName", "com.miui.calculator" } });
    m_applications << QVariantMap({ { "name","Carteira de Trabalho Digital" }, { "packageName", "br.gov.dataprev.carteiradigital" } });
    m_applications << QVariantMap({ { "name","Carteira Digital de Trânsito" }, { "packageName", "br.gov.serpro.cnhe" } });
    m_applications << QVariantMap({ { "name","Chrome" }, { "packageName", "com.android.chrome" } });
    m_applications << QVariantMap({ { "name","Clima" }, { "packageName", "com.miui.weather2" } });
    m_applications << QVariantMap({ { "name","Configurações" }, { "packageName", "com.android.settings" } });
    m_applications << QVariantMap({ { "name","Contatos" }, { "packageName", "com.google.android.contacts" } });
    m_applications << QVariantMap({ { "name","Câmera" }, { "packageName", "com.android.camera" } });
    m_applications << QVariantMap({ { "name","Câmera" }, { "packageName", "org.codeaurora.snapcam" } });
    m_applications << QVariantMap({ { "name","Digitalizador" }, { "packageName", "com.xiaomi.scanner" } });
    */
#endif

    emit applicationsChanged();
}

void RaskLauncher::newApplication(const QString &packageName)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject application = QAndroidJniObject::callStaticObjectMethod("com/QtRask/Launcher/RaskLauncher",
                                                                              "getApplicationData",
                                                                              "(Ljava/lang/String;)Lcom/QtRask/Launcher/Application;",
                                                                              QAndroidJniObject::fromString(packageName).object<jstring>());

    QString name = UtilsJni::jstringToQString((application.callObjectMethod<jstring>("getName")).object<jstring>());
    QString package = UtilsJni::jstringToQString((application.callObjectMethod<jstring>("getPackageName")).object<jstring>());
    QString iconType = UtilsJni::jstringToQString((application.callObjectMethod<jstring>("getIconType")).object<jstring>());

    qDebug() << "Applications" << m_applications.size();
    qDebug() << "Added" << name << package << iconType;

    m_applications << QVariantMap({
                                      { "name", name },
                                      { "packageName", package },
                                      { "adaptativeIcon", iconType == "Adaptative" }
                                  });

    qDebug().noquote() << QJsonDocument::fromVariant(m_applications).toJson(QJsonDocument::Indented);
    std::sort(m_applications.begin(), m_applications.end(), [](const QVariant &a, const QVariant &b) -> bool { return a.toMap()["name"] < b.toMap()["name"]; });
    emit applicationsChanged();
#endif
}

void RaskLauncher::removedApplication(const QString &packageName)
{
    qDebug() << "Pacote removido" << packageName << m_applications.size();

    const auto &it = std::find_if(m_applications.begin(), m_applications.end(), [packageName](const QVariant &it) { return it.toMap()["packageName"] == packageName; });
    m_applications.erase(it);
    emit applicationsChanged();
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
#endif
}

void RaskLauncher::registerMethods()
{
    registerNativeMethods();
}

QVariantList RaskLauncher::applications()
{
    return m_applications;
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
