#pragma once

#include <QAbstractListModel>
#include <QFile>
#include <QObject>
#include <QVariant>

class JSONAbstractListModel
{
public:
    explicit JSONAbstractListModel(QString fileName);

    QString getFileName() const;
    void setFileName(const QString &fileName);

    QVariant getJSONData();
    void setJSONData(const QVariant &value);

private:
    QString m_fileName;
    QFile m_fileData;

    const int fileType = 0x5261736b;
    const int fileVersion = 101;
    const int compressionLevel = 9;
};

