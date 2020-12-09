#include "connectiondb.h"

#include <QSqlError>
#include <QDebug>

QSqlDatabase ConnectionDB::create()
{
    if (QSqlDatabase::contains(QSqlDatabase::defaultConnection))
        return QSqlDatabase::database(QSqlDatabase::defaultConnection);

    QSqlDatabase db = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"));
    db.setDatabaseName(QStringLiteral("data.db"));
    return db;
}
