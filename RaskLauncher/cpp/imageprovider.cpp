#include "imageprovider.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

#include <QDebug>

ImageProvider::ImageProvider():
    QQuickImageProvider(QQuickImageProvider::Image)
{}

QImage ImageProvider::requestImage(const QString &id, QSize */*size*/, const QSize &/*requestedSize*/)
{
    QImage image;
#ifdef Q_OS_ANDROID

    QAndroidJniObject imageByteArray;

    if (id == QStringLiteral("wallpaper"))
    {
        imageByteArray = QAndroidJniObject::callStaticObjectMethod("com/QtRask/Launcher/RaskLauncher",
                                                                   "getWallpaperImage",
                                                                   "()[B");
    }
    else
    {
        imageByteArray = QAndroidJniObject::callStaticObjectMethod("com/QtRask/Launcher/RaskLauncher",
                                                                   "getApplicationIcon",
                                                                   "(Ljava/lang/String;)[B",
                                                                   QAndroidJniObject::fromString(id).object<jstring>());
    }

    QAndroidJniEnvironment env;
    jbyteArray iconDataArray = imageByteArray.object<jbyteArray>();

    if (!iconDataArray)
    {
        qDebug() << Q_FUNC_INFO << "No icon found" << id;
        return image;
    }

    jsize iconSize = env->GetArrayLength(iconDataArray);
    if (iconSize > 0)
    {
        jbyte *icon = env->GetByteArrayElements(iconDataArray, nullptr);
        image = QImage::fromData(reinterpret_cast<uchar *>(icon), iconSize, "PNG");
        env->ReleaseByteArrayElements(iconDataArray, icon, JNI_ABORT);
    }
#else
    if (id == QStringLiteral("wallpaper"))
        image = QImage(QStringLiteral(":/img/wallpaper.jpg"));
    else
        image = QImage(QStringLiteral(":/img/qc-icon.png"));
#endif

    return image;
}
