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
        AdaptativeIcon
    };

    void addApplications(QVariantList &list);
    void addApplication(const QVariantMap &application);
    void removeApplication(const QString &packageName);

    void sort(QVariantList &value, int column, Qt::SortOrder order = Qt::AscendingOrder);

    QVariantList getList() const;
    QVariantList getHidden() const;
    QVariantList getDock() const;
    QVariantList getSearchList();

public slots:
    void hideApplication(const QString &packageName);
    void showApplication(const QString &packageName);

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
    QVariantList m_applicationsHidden;
    QVariantList m_applicationsDock;

    const QString m_fieldApplications;
    const QString m_fieldHidden;
    const QString m_fieldDock;

    void newApplication(const QVariantMap &application);
    void refreshApplicationsList();

    QVariantList::iterator find(QVariantList &list, const QString &searchFor, ModelRoles field = ModelRoles::Package);
    bool findAndRemove(QVariantList &listSource, QVariantList &listTarget);
    bool findAndRemove(const QString &packageName, QVariantList &listTarget);
};

