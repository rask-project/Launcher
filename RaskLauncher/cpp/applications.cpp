#include "applications.h"
#include "imageprovider.h"
#include "singleton.h"

#include <QJsonDocument>
#include <QHash>
#include <QDebug>

Applications::Applications(QObject *parent) :
    QObject(parent),
    jsonModel(QStringLiteral("applications")),
    m_fields({ QStringLiteral("name"), QStringLiteral("packageName"), QStringLiteral("visible"), QStringLiteral("adaptativeIcon"), QStringLiteral("orderDock") }),
    m_modifiedList(false),
    m_fieldApplications(QStringLiteral("applications")),
    m_fieldPackageName(QStringLiteral("packageName")),
    m_fieldOrderDock(QStringLiteral("orderDock"))
{
    m_applications << jsonModel.getJSONData().toMap()[m_fieldApplications].toList();
    connect(this, &Applications::listChanged, this, &Applications::searchListChanged);
}

void Applications::addApplications(QVariantList &list)
{
    findAndRemove(list, m_applications);

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
    findAndRemove(packageName, m_applications);
    refreshApplicationsList();
}

void Applications::sort(QVariantList &value, int column, Qt::SortOrder order)
{
    std::sort(value.begin(), value.end(), [=](const QVariant &a, const QVariant &b) -> bool
    {
        return order == Qt::AscendingOrder ?
                    a.toMap()[m_fields[column - Qt::UserRole]].toString().toLower() < b.toMap()[m_fields[column - Qt::UserRole]].toString().toLower() :
                    a.toMap()[m_fields[column - Qt::UserRole]].toString().toLower() > b.toMap()[m_fields[column - Qt::UserRole]].toString().toLower();
    });
}

QVariantList Applications::getList() const
{
    return m_applicationsList;
}

void Applications::setList()
{
    m_applicationsList.clear();
    std::copy_if(m_applications.begin(), m_applications.end(), std::back_inserter(m_applicationsList), [](const QVariant &it)
    {
        return it.toMap()[QStringLiteral("visible")].toBool();
    });
    emit listChanged();
}

QVariantList Applications::getHidden() const
{
    return m_applicationsHidden;
}

void Applications::setHidden()
{
    m_applicationsHidden.clear();
    std::copy_if(m_applications.begin(), m_applications.end(), std::back_inserter(m_applicationsHidden), [](const QVariant &it)
    {
        return !it.toMap()[QStringLiteral("visible")].toBool();
    });

    emit hiddenChanged();
}

QVariantList Applications::getDock() const
{
    return m_applicationsDock;
}

void Applications::setDock()
{
    m_applicationsDock.clear();
    std::copy_if(m_applications.begin(), m_applications.end(), std::back_inserter(m_applicationsDock), [=](const QVariant &it)
    {
        return it.toMap().contains(m_fieldOrderDock);
    });

    sort(m_applicationsDock, OrderDock);
    emit dockChanged();
}

QVariantList Applications::getSearchList()
{
    return m_applications;
}

void Applications::changeVisibility(const QString &packageName)
{
    changeValueBoolean(packageName, QStringLiteral("visible"));
}

void Applications::addToDock(const QString &packageName, int order)
{
    qDebug() << "Add Application to Dock" << packageName << order;

    if (order >= 0) {
        for (auto &itDock : m_applicationsDock) {
            auto app = itDock.toMap();
            auto fieldOrderDock = app[m_fieldOrderDock];
            if (fieldOrderDock.isValid() && fieldOrderDock.toInt() >= order) {
                auto pos = app[m_fieldOrderDock].toInt();
                app[m_fieldOrderDock] = ++pos;

                auto itApp = find(m_applications, app[m_fieldPackageName].toString());
                itApp.i->t() = app;
            }
        }
    }

    auto app = find(m_applications, packageName);
    auto it = app->toMap();
    it[m_fieldOrderDock] = (order < 0) ? m_applicationsDock.size() : order;
    app.i->t() = it;

    m_modifiedList = true;
    refreshApplicationsList();
}

void Applications::removeFromDock(const QString &packageName)
{
    qDebug() << "Remove App from Dock" << packageName;

    auto app = find(m_applications, packageName);
    QVariantMap it = app->toMap();
    auto orderDock = it[m_fieldOrderDock].toInt();
    it.remove(m_fieldOrderDock);

    app.i->t() = it;

    for (auto &itDock : m_applicationsDock) {
        auto app = itDock.toMap();

        if (app[m_fieldPackageName].toString() == packageName)
            app = it;

        auto fieldOrderDock = app[m_fieldOrderDock];
        if (fieldOrderDock.isValid() && fieldOrderDock.toInt() >= orderDock) {
            auto pos = fieldOrderDock.toInt();
            app[m_fieldOrderDock] = --pos;

            auto itApp = find(m_applications, app[m_fieldPackageName].toString());
            itApp.i->t() = app;
        }
    }

    m_modifiedList = true;
    refreshApplicationsList();
}

void Applications::toggleDock(const QString &packageName)
{
    changeValueBoolean(packageName, QStringLiteral("dock"));
}

void Applications::changeValueBoolean(const QString &packageName, const QString &key)
{
    auto app = find(m_applications, packageName);

    QVariantMap it = app->toMap();
    it[key] = !it[key].toBool();
    m_applications.erase(app);
    m_applications << it;

    m_modifiedList = true;
    refreshApplicationsList();
}

void Applications::newApplication(const QVariantMap &application)
{
    if (find(m_applications, application[QStringLiteral("packageName")].toString()) != std::end(m_applications)) {
        return;
    }

    qDebug() << "New Application" << application[QStringLiteral("packageName")].toString();
    m_applications << application;
    m_modifiedList = true;
}

void Applications::refreshApplicationsList()
{
    sort(m_applications, Name, Qt::AscendingOrder);
    sort(m_applicationsHidden, Name, Qt::AscendingOrder);

    setList();
    setHidden();
    setDock();

    if (!m_modifiedList)
        return;

    QVariantMap applications = QVariantMap({
                                               { m_fieldApplications, m_applications }
                                           });

    //qDebug().noquote() << QJsonDocument::fromVariant(m_applications).toJson(QJsonDocument::Indented);

    jsonModel.setJSONData(applications);
    m_modifiedList = false;
}

QVariantList::iterator Applications::find(QVariantList &list, const QString &searchFor, Applications::ModelRoles field)
{
    return std::find_if(std::begin(list), std::end(list), [=](const QVariant &it)
    {
        return it.toMap()[m_fields[field - Qt::UserRole]].toString() == searchFor;
    });
}

bool Applications::findAndRemove(QVariantList &listSource, QVariantList &listTarget)
{
    ImageProvider &imageProvider = Singleton<ImageProvider>::getInstance();

    bool atLeastOne = false;
    for (const auto &itApp: qAsConst(listTarget)) {
        const QVariantMap &app = itApp.toMap();

        const auto &finded = find(listSource, app[QStringLiteral("packageName")].toString());
        if (finded == std::end(listSource)) {
            qDebug() << "App removed" << app[QStringLiteral("packageName")].toString();
            imageProvider.removeImageCache(app[QStringLiteral("packageName")].toString());

            listTarget.removeOne(itApp);
            atLeastOne = true;
            m_modifiedList = true;
        }
    }
    return atLeastOne;
}

bool Applications::findAndRemove(const QString &packageName, QVariantList &listTarget)
{
    const auto &it = find(listTarget, packageName);
    if (it == std::end(listTarget))
        return false;

    ImageProvider &imageProvider = Singleton<ImageProvider>::getInstance();
    imageProvider.removeImageCache(packageName);
    listTarget.erase(it);

    qDebug() << "Application Removed" << packageName;
    m_modifiedList = true;

    return true;
}
