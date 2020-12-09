#pragma once
#include <QQmlEngine>

template<typename MyClass>
class Singleton final
{
public:
    static MyClass& getInstanceQML(QQmlEngine *qmlEngine = nullptr, QJSEngine *qjsEngine = nullptr)
    {
        Q_UNUSED(qmlEngine);
        Q_UNUSED(qjsEngine);

        static MyClass instance;
        return instance;
    }

    static MyClass& getInstance()
    {
        static MyClass instance;
        return instance;
    }

private:
    Singleton() = default;
    ~Singleton() = default;

    Singleton(const Singleton&) = delete;
    Singleton& operator = (const Singleton&) = delete;
    Singleton(Singleton&&) = delete;
    Singleton& operator = (Singleton&&) = delete;
};
