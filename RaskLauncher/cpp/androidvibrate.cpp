#include "androidvibrate.h"
#include <QDebug>

AndroidVibrate::AndroidVibrate(QObject *parent) :
    QObject(parent),
    m_activity(QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;"))
{}

void AndroidVibrate::vibrate(long milliseconds, AndroidVibrate::VibrationEffect effect)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/QtRask/Launcher/RaskLauncher",
                                              "vibrate", "(JI)V",
                                              milliseconds, static_cast<int>(effect));
#else
    qDebug() << "Vibrate" << milliseconds << effect;
#endif
}
