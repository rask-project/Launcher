#include "rasktheme.h"
#include <QDebug>

RaskTheme::RaskTheme(QObject *parent) :
    QObject(parent),
    m_theme(Theme::Light),
    m_systemTheme(Theme::Light),
    m_useSystemTheme(false)
{
    connect(this, &RaskTheme::themeChanged, this, [=]() {
        emit backgroundChanged();
        emit iconBackgroundChanged();
        emit iconBorderColorChanged();
        emit iconShadowChanged();
        emit iconImageShadowChanged();
        emit iconPressedChanged();
        emit popupBackgroundChanged();
    });
}

QColor RaskTheme::background() const
{
    return m_theme == Theme::Light ? QColor::fromRgba(Colors::LightGrey) : QColor::fromRgba(Colors::DarkerGrey);
}

QColor RaskTheme::iconBackground() const
{
    QColor color = m_theme == Theme::Light ? QColor::fromRgba(Colors::LightGrey) : QColor::fromRgba(Colors::DarkerGrey);
    color.setAlpha(static_cast<int>(Opacity::Alpha50));
    return color;
}

QColor RaskTheme::iconBorderColor() const
{
    QColor color = m_theme == Theme::Light ? QColor::fromRgba(Colors::Grey) : QColor::fromRgba(Colors::DarkestGrey);
    color.setAlpha(static_cast<int>(Opacity::Alpha50));
    return color;
}

QColor RaskTheme::iconShadow()
{
    return QColor::fromRgba(Colors::MediumDarkGrey);
}

QColor RaskTheme::iconImageShadow() const
{
    return m_theme == Theme::Light ? QColor::fromRgba(Colors::MediumDarkGrey) : QColor::fromRgba(Colors::LightGrey);
}

QColor RaskTheme::iconPressed() const
{
    QColor color = m_theme == Theme::Light ? QColor::fromRgba(Colors::White) : QColor::fromRgba(Colors::Black);
    color.setAlpha(static_cast<int>(Opacity::Alpha30));
    return color;
}

void RaskTheme::identifyThemeColor(Theme theme)
{
    if (theme == m_theme)
        return;

    if (m_useSystemTheme) {
        m_theme = m_systemTheme;
        qDebug() << "Using theme system" << m_theme;
    } else {
        m_theme = theme;
        qDebug() << "Using theme from user" << m_theme;
    }

    emit themeChanged();
}

void RaskTheme::setSystemTheme(RaskTheme::Theme theme)
{
    qDebug() << "Identified system theme" << theme;
    m_systemTheme = theme;
    identifyThemeColor(m_useSystemTheme ? Theme::System : m_theme);
}

QColor RaskTheme::getColor(RaskTheme::Colors color, RaskTheme::Opacity opacity)
{
    QColor qcolor = QColor::fromRgba(color);
    qcolor.setAlpha(static_cast<int>(opacity));
    return qcolor;
}

void RaskTheme::setTheme(RaskTheme::Theme theme)
{
    qDebug() << "Change theme" << theme;
    m_useSystemTheme = theme == Theme::System;
    identifyThemeColor(theme);
}

QColor RaskTheme::inputBackground()
{
    QColor color = QColor::fromRgba(Colors::MediumDarkGrey);
    color.setAlpha(static_cast<int>(Opacity::Alpha40));
    return color;
}

QColor RaskTheme::popupBackground() const
{
    QColor color = m_theme == Theme::Light ? QColor::fromRgba(Colors::LightGrey) : QColor::fromRgba(Colors::DarkerGrey);
    color.setAlpha(static_cast<int>(Opacity::Alpha90));
    return color;
}

RaskTheme::Theme RaskTheme::theme() const
{
    return m_theme;
}
