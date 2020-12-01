#pragma once

#include <QQuickImageProvider>

class ImageProvider : public QQuickImageProvider
{
    ImageProvider(const ImageProvider &) = delete;
    ImageProvider& operator=(const ImageProvider &) = delete;

public:
    explicit ImageProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
};

