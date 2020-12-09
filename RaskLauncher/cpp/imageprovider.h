#pragma once

#include <QQuickImageProvider>
#include "jsonabstractlistmodel.h"

class ImageProvider : public QQuickImageProvider
{
    ImageProvider(const ImageProvider &) = delete;
    ImageProvider& operator=(const ImageProvider &) = delete;

public:
    explicit ImageProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

    void removeImageCache(const QString &id);

private:
    JSONAbstractListModel jsonModel;
    QMap<QString, QVariant> m_images;
    bool m_waitToSave;
    const int m_msecsWait = 2500;

    void setImage(const QString &packageName, const QByteArray &data);
};

