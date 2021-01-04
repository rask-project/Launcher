#pragma once

#include <QObject>

class ScreenManager : public QObject
{
    Q_PROPERTY(float density READ getDensity WRITE setDensity NOTIFY densityChanged)
    Q_PROPERTY(int statusBarHeight READ getStatusBarHeight WRITE setStatusBarHeight NOTIFY statusBarHeightChanged)
    Q_PROPERTY(int navigationBarHeight READ getNavigationBarHeight WRITE setNavigationBarHeight NOTIFY navigationBarHeightChanged)
    Q_PROPERTY(int navigationBarHeightLandscape READ getNavigationBarHeightLandscape WRITE setNavigationBarHeightLandscape NOTIFY navigationBarHeightLandscapeChanged)

    Q_OBJECT
public:
    explicit ScreenManager(QObject *parent = nullptr);

    float getDensity() const;
    void setDensity(float density);

    int getStatusBarHeight() const;
    void setStatusBarHeight(int value);

    int getNavigationBarHeight() const;
    void setNavigationBarHeight(int value);

    int getNavigationBarHeightLandscape() const;
    void setNavigationBarHeightLandscape(int value);

public slots:
    void updateScreenValues();

signals:
    void densityChanged();
    void statusBarHeightChanged();
    void navigationBarHeightChanged();
    void navigationBarHeightLandscapeChanged();

private:
    float m_density;
    int m_statusBarHeight;
    int m_navigationBarHeight;
    int m_navigationBarHeightLandscape;

    int getResourceSize(const QString &value);
    float getDensity();
};

