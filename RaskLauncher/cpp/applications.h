#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QVariant>
#include "jsonabstractlistmodel.h"

class Applications : public QObject
{
    Q_PROPERTY(QVariantList data READ getData NOTIFY dataChanged)
    Q_OBJECT
public:
    explicit Applications(QObject *parent = nullptr);

    enum ModelRoles {
        Name = Qt::UserRole,
        Package,
        Visible,
        AdaptativeIcon
    };

    void addApplications(const QVariantList &list);
    void addApplication(const QVariantMap &application);
    void removeApplication(const QString &packageName);

    void sort(int column, Qt::SortOrder order = Qt::AscendingOrder);

    QVariantList getData() const;

signals:
    void dataChanged();

private:
    JSONAbstractListModel jsonModel;
    const QStringList m_fields;
    QVariantList m_data;

    void newApplication(const QVariantMap &application);
    void refreshApplicationsList();
};

