#include "applications.h"
#include "connectiondb.h"
#include "imageprovider.h"
#include "singleton.h"

#include <QHash>
#include <QDebug>

Applications::Applications(QObject *parent) :
    QAbstractListModel(parent),
    jsonModel(QStringLiteral("applications")),
    m_fields({ QStringLiteral("name"), QStringLiteral("packageName"), QStringLiteral("visible"), QStringLiteral("adaptativeIcon") })
{
    m_data << jsonModel.getJSONData().toList();
}

int Applications::rowCount(const QModelIndex &/*parent*/) const
{
    return m_data.size();
}

QVariant Applications::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.size())
        return QVariant();
    return m_data.at(index.row()).toMap()[m_fields[role - Qt::UserRole]];
}

QHash<int, QByteArray> Applications::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames[Name] = "name";
    roleNames[Package] = "packageName";
    roleNames[Visible] = "visible";
    roleNames[AdaptativeIcon] = "adaptativeIcon";
    return roleNames;
}

void Applications::addApplications(const QVariantList &list)
{
    ImageProvider &imageProvider = Singleton<ImageProvider>::getInstance();

    for (const auto &itApp: qAsConst(m_data)) {
        const QVariantMap &app = itApp.toMap();

        const auto &finded = std::find_if(list.begin(), list.end(), [&app](const QVariant &it)
        {
            return app[QStringLiteral("packageName")].toString() == it.toMap()[QStringLiteral("packageName")].toString();
        });

        if (finded == list.end()) {
            qDebug() << "App removed" << app[QStringLiteral("packageName")].toString();
            imageProvider.removeImageCache(app[QStringLiteral("packageName")].toString());

            m_data.removeOne(itApp);
        }
    }

    for (const auto &application : qAsConst(list)) {
        newApplication(application.toMap());
    }

    refreshApplicationsList();
}

void Applications::addApplication(const QVariantMap &application)
{
    newApplication(application);
    refreshApplicationsList();
}

void Applications::removeApplication(const QString &packageName)
{
    const auto &it = std::find_if(m_data.begin(), m_data.end(), [packageName](const QVariant &it)
    {
        return it.toMap()[QStringLiteral("packageName")] == packageName;
    });
    m_data.erase(it);

    qDebug() << "Application Removed" << packageName;
    refreshApplicationsList();
}

void Applications::sort(int column, Qt::SortOrder order)
{
    std::sort(m_data.begin(), m_data.end(), [=](const QVariant &a, const QVariant &b) -> bool
    {
        return order == Qt::AscendingOrder ?
                    a.toMap()[m_fields[column - Qt::UserRole]].toString().toLower() < b.toMap()[m_fields[column - Qt::UserRole]].toString().toLower() :
                    a.toMap()[m_fields[column - Qt::UserRole]].toString().toLower() > b.toMap()[m_fields[column - Qt::UserRole]].toString().toLower();
    });
}

void Applications::newApplication(const QVariantMap &application)
{
    const auto &app = std::find_if(m_data.begin(), m_data.end(), [application](const QVariant &it)
    {
        return it.toMap()[QStringLiteral("packageName")].toString() == application[QStringLiteral("packageName")].toString();
    });

    if (app != std::end(m_data)) {
        return;
    }

    qDebug() << "New Application" << application[QStringLiteral("packageName")].toString();
    m_data << application;
}

void Applications::refreshApplicationsList()
{
    sort(Name, Qt::AscendingOrder);
    beginResetModel();
    endResetModel();

    jsonModel.setJSONData(m_data);
}