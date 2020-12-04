#pragma once

#include <QObject>

class ScreenManager : public QObject
{
    Q_PROPERTY(int statusBarHeight READ getStatusBarHeight WRITE setStatusBarHeight NOTIFY statusBarHeightChanged)
    Q_PROPERTY(int navigationBarHeight READ getNavigationBarHeight WRITE setNavigationBarHeight NOTIFY navigationBarHeightChanged)
    Q_PROPERTY(int navigationBarHeightLandscape READ getNavigationBarHeightLandscape WRITE setNavigationBarHeightLandscape NOTIFY navigationBarHeightLandscapeChanged)

    Q_OBJECT
public:
    explicit ScreenManager(QObject *parent = nullptr);

    int getStatusBarHeight() const;
    void setStatusBarHeight(int statusBarHeight);

    int getNavigationBarHeight() const;
    void setNavigationBarHeight(int navigationBarHeight);

    int getNavigationBarHeightLandscape() const;
    void setNavigationBarHeightLandscape(int navigationBarHeightLandscape);

public slots:
    void updateScreenValues();

signals:
    void statusBarHeightChanged();
    void navigationBarHeightChanged();
    void navigationBarHeightLandscapeChanged();

private:
    int m_statusBarHeight;
    int m_navigationBarHeight;
    int m_navigationBarHeightLandscape;

    int getResourceSize(const QString &value);
};

