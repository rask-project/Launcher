#include "jsonabstractlistmodel.h"

#include <QJsonDocument>
#include <QJsonParseError>
#include <QDataStream>
#include <QDebug>
#include <utility>

JSONAbstractListModel::JSONAbstractListModel(QString fileName):
    m_fileName(std::move(fileName)),
    m_fileData(m_fileName)
{}

QString JSONAbstractListModel::getFileName() const
{
    return m_fileName;
}

void JSONAbstractListModel::setFileName(const QString &fileName)
{
    if (m_fileName == fileName)
        return;

    m_fileName = fileName;
    m_fileData.setFileName(m_fileName);
}

QVariant JSONAbstractListModel::getJSONData()
{
    if (!m_fileData.exists()) {
        qCritical() << "File data not found" << m_fileData.fileName();
        return {};
    }

    if (!m_fileData.open(QIODevice::ReadOnly)) {
        qDebug() << "Error trying open file" << m_fileData.fileName() << m_fileData.errorString();
        return {};
    }

    QDataStream in(&m_fileData);

    int type = 0;
    in >> type;
    if (type != fileType) {
        qCritical() << "Error: the file is not a valid data type" << m_fileData.fileName();
        m_fileData.close();
        return {};
    }

    QByteArray data;
    in >> data;

    QJsonParseError error{};
    QJsonDocument doc = QJsonDocument::fromJson(qUncompress(data), &error);
    if (error.error != QJsonParseError::NoError) {
        qCritical() << "Error trying parse JSON file" << m_fileData.fileName() << error.errorString();
        m_fileData.close();
        return QVariant();
    }

    m_fileData.close();
    return doc.toVariant();
}

void JSONAbstractListModel::setJSONData(const QVariant &value)
{
    if (!m_fileData.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        qDebug() << "Error trying open file data" << m_fileData.fileName();
        return;
    }

    QDataStream out(&m_fileData);
    out << fileType;
    out << qCompress(QJsonDocument::fromVariant(value).toJson(QJsonDocument::Compact), compressionLevel);

    m_fileData.close();

    qDebug() << m_fileData.fileName() << m_fileData.size();
}
