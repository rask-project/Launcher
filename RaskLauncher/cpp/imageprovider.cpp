#include "imageprovider.h"

#include <QBuffer>
#include <QFile>
#include <QTimer>
#include <algorithm>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

#include <QDebug>

ImageProvider::ImageProvider():
    QQuickImageProvider(QQuickImageProvider::Image),
    jsonModel(QStringLiteral("images")),
    m_waitToSave(false)
{
    m_images = jsonModel.getJSONData().toMap();
}

QImage ImageProvider::requestImage(const QString &id, QSize */*size*/, const QSize &/*requestedSize*/)
{
    QImage image;
    if (m_images.contains(id)) {
        image = QImage::fromData(QByteArray::fromBase64(m_images[id].toByteArray()));
        return image;
    }

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

        setImage(id, QByteArray::fromRawData(reinterpret_cast<char *>(icon), iconSize));
    }
#else
    QFile imgFile(id == QStringLiteral("wallpaper") ? QStringLiteral(":/img/wallpaper.jpg") : QStringLiteral(":/applications/%1.svg").arg(id));
    if (imgFile.open(QIODevice::ReadOnly)) {
        QByteArray byteArrayImage = imgFile.readAll();
        imgFile.close();

        image = QImage::fromData(byteArrayImage);
        setImage(id, byteArrayImage);
    } else {
        qDebug() << "Error trying open file" << imgFile.fileName();
    }
#endif

    return image;
}

void ImageProvider::removeImageCache(const QString &id)
{
    m_images.remove(id);
    jsonModel.setJSONData(m_images);
}

void ImageProvider::setImage(const QString &packageName, const QByteArray &data)
{
    if (packageName == QStringLiteral("wallpaper"))
        return;

    m_images[packageName] = data.toBase64();

    if (!m_waitToSave) {
        m_waitToSave = true;

        QTimer::singleShot(m_msecsWait, [=]() // clazy:exclude=connect-3arg-lambda
        {
            m_waitToSave = false;
            jsonModel.setJSONData(m_images);
        });
    }
}
