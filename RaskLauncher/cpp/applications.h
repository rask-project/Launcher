#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QVariant>
#include "jsonabstractlistmodel.h"

class Applications : public QObject
{
    Q_PROPERTY(QVariantList list READ getList NOTIFY listChanged)
    Q_PROPERTY(QVariantList hidden READ getHidden NOTIFY hiddenChanged)
    Q_PROPERTY(QVariantList dock READ getDock NOTIFY dockChanged)
    Q_PROPERTY(QVariantList searchList READ getSearchList NOTIFY searchListChanged)
    Q_OBJECT
public:
    explicit Applications(QObject *parent = nullptr);

    enum ModelRoles {
        Name = Qt::UserRole,
        Package,
        Visible,
        AdaptativeIcon,
        OrderDock
    };

    void addApplications(QVariantList &list);
    void addApplication(const QVariantMap &application);
    void removeApplication(const QString &packageName);

    void sort(QVariantList &value, int column, Qt::SortOrder order = Qt::AscendingOrder);

    QVariantList getList() const;
    void setList();

    QVariantList getHidden() const;
    void setHidden();

    QVariantList getDock() const;
    void setDock();

    QVariantList getSearchList();

public slots:
    void changeVisibility(const QString &packageName);
    void addToDock(const QString &packageName, int order = -1);
    void removeFromDock(const QString &packageName);

    void toggleDock(const QString &packageName);

private slots:
    void changeValueBoolean(const QString &packageName, const QString &key);

signals:
    void listChanged();
    void hiddenChanged();
    void dockChanged();
    void searchListChanged();

private:
    JSONAbstractListModel jsonModel;
    const QStringList m_fields;
    bool m_modifiedList;

    QVariantList m_applications;
    QVariantList m_applicationsList;
    QVariantList m_applicationsHidden;
    QVariantList m_applicationsDock;

    const QString m_fieldApplications;
    const QString m_fieldPackageName;
    const QString m_fieldOrderDock;

    void newApplication(const QVariantMap &application);
    void refreshApplicationsList();

    QVariantList::iterator find(QVariantList &list, const QString &searchFor, ModelRoles field = ModelRoles::Package);
    bool findAndRemove(QVariantList &listSource, QVariantList &listTarget);
    bool findAndRemove(const QString &packageName, QVariantList &listTarget);
};

