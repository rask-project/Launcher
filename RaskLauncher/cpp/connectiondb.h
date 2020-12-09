#pragma once

#include <QSqlDatabase>
#include <QString>

class ConnectionDB
{
public:
    explicit ConnectionDB() = default;
    ~ConnectionDB() = default;

    static QSqlDatabase create();
};

