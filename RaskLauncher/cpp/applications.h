#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QVariant>
#include "jsonabstractlistmodel.h"

class Applications : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit Applications(QObject *parent = nullptr);

    enum ModelRoles {
        Name = Qt::UserRole,
        Package,
        Visible,
        AdaptativeIcon
    };

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addApplications(const QVariantList &list);
    void addApplication(const QVariantMap &application);
    void removeApplication(const QString &packageName);

    void sort(int column, Qt::SortOrder order) override;

signals:
    void countChanged(int count);

private:
    JSONAbstractListModel jsonModel;
    const QStringList m_fields;
    QVariantList m_data;

    void newApplication(const QVariantMap &application);
    void refreshApplicationsList();
};

