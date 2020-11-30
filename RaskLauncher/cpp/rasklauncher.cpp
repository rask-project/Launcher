#include "rasklauncher.h"

#include <QDebug>

#ifdef Q_OS_ANDROID
#include "utilsJni.h"
#include <QAndroidJniEnvironment>
#endif

#ifdef Q_OS_ANDROID
static void newIntent(JNIEnv */*env*/, jobject /*obj*/, jlong /*qtObject*/)
{
    qDebug() << "New Intent C++";
}
#endif

RaskLauncher::RaskLauncher(QObject *parent) :
    QObject(parent)
#ifdef Q_OS_ANDROID
    , m_activity(QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;"))
    , m_intentFilter(QAndroidJniObject("android/content/IntentFilter"))
//    , m_broadcastReceiver(QAndroidJniObject("com/QtRask/Launcher/PackageBroadcast"))
#endif
{
    registerNativeMethods();
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
#endif

    emit applicationsChanged();
}

void RaskLauncher::launchApplication(const QString &application)
{
#ifdef Q_OS_ANDROID
    qDebug() << "Launch Application" << application;
    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher",
                                              "launchApplication",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(application).object<jstring>());
#else
    qDebug() << "Launche Application" << application;
#endif
}

bool RaskLauncher::isLaunchableApplication(const QString &/*application*/)
{
//#ifdef Q_OS_ANDROID
//    qDebug() << "Launchable Application" << application;
//    QAndroidJniObject objIsLaunchable = QAndroidJniObject::callStaticObjectMethod("com/QtRask/Launcher/RaskLauncher",
//                                                                                  "isLaunchableApplication",
//                                                                                  "(Ljava/lang/String;)Z",
//                                                                                  QAndroidJniObject::fromString(application).object<jstring>());
//    jboolean isLaunchable = objIsLaunchable.object<jboolean>();
////    return isLaunchable;
//#endif
    return true;
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
    JNINativeMethod methods[] {{ "kNewIntent", "(J)V", reinterpret_cast<void *>(newIntent) }};

    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher",
                                              "setQtObject", "(J)V",
                                              "(J)V", reinterpret_cast<long>(this));

    QAndroidJniEnvironment env;
    jclass objectClass = env->GetObjectClass(m_activity.object<jobject>());

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
