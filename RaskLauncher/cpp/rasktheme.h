#pragma once

#include <QObject>
#include <QColor>

class RaskTheme : public QObject
{
    Q_PROPERTY(Theme theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(QColor background READ background NOTIFY backgroundChanged)
    Q_PROPERTY(QColor popupBackground READ popupBackground NOTIFY popupBackgroundChanged)
    Q_PROPERTY(QColor iconBackground READ iconBackground NOTIFY iconBackgroundChanged)
    Q_PROPERTY(QColor iconBorderColor READ iconBorderColor NOTIFY iconBorderColorChanged)
    Q_PROPERTY(QColor iconShadow READ iconShadow NOTIFY iconShadowChanged)
    Q_PROPERTY(QColor iconImageShadow READ iconImageShadow NOTIFY iconImageShadowChanged)
    Q_PROPERTY(QColor iconPressed READ iconPressed NOTIFY iconPressedChanged)
    Q_PROPERTY(QColor inputBackground READ inputBackground NOTIFY inputBackgroundChanged)

    Q_OBJECT
public:
    explicit RaskTheme(QObject *parent = nullptr);

    enum class Theme
    {
        Light,
        Dark,
        System
    };
    Q_ENUM(Theme)

    enum Colors
    {
        White = 0xFFFFFFFF,
        LighterGrey = 0xFFD1D1D1,
        LightGrey = 0xFFC7C7C7,
        Grey = 0xFFAEAEAE,
        MediumDarkGrey = 0xFF8E8E8E,
        DarkGrey = 0xFF3A3A3A,
        DarkerGrey = 0xFF2C2C2C,
        DarkestGrey = 0xFF1C1C1C,
        Black = 0xFF000000
    };
    Q_ENUM(Colors)

    enum class Opacity
    {
        Alpha0 = 0x00,
        Alpha5 = 0x0D,
        Alpha10 = 0x1A,
        Alpha15 = 0x26,
        Alpha20 = 0x33,
        Alpha25 = 0x40,
        Alpha30 = 0x4D,
        Alpha35 = 0x59,
        Alpha40 = 0x66,
        Alpha45 = 0x73,
        Alpha50 = 0x80,
        Alpha55 = 0x8C,
        Alpha60 = 0x99,
        Alpha65 = 0xA6,
        Alpha70 = 0xB3,
        Alpha75 = 0xBF,
        Alpha80 = 0xCC,
        Alpha85 = 0xD9,
        Alpha90 = 0xE6,
        Alpha95 = 0xF2,
        Alpha100 = 0xFF
    };
    Q_ENUM(Opacity)

    QColor background() const;
    QColor iconBackground() const;
    QColor iconBorderColor() const;
    static QColor iconShadow();
    QColor iconImageShadow() const;
    QColor iconPressed() const;

    static QColor inputBackground();
    QColor popupBackground() const;

    Theme theme() const;

    void setSystemTheme(Theme theme);

public slots:
    void setTheme(Theme theme);
    static QColor getColor(Colors color, Opacity opacity = Opacity::Alpha100);

private slots:
    void identifyThemeColor(Theme theme);

signals:
    void backgroundChanged();
    void iconBackgroundChanged();
    void iconBorderColorChanged();
    void iconShadowChanged();
    void iconImageShadowChanged();
    void iconPressedChanged();
    void inputBackgroundChanged();
    void popupBackgroundChanged();

    void themeChanged();

private:
    Theme m_theme;
    Theme m_systemTheme;
    bool m_useSystemTheme;
};
