#pragma once

#include <QObject>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

class AndroidVibrate : public QObject
{
    Q_OBJECT
public:
    explicit AndroidVibrate(QObject *parent = nullptr);

    enum class VibrationEffect
    {
        DEFAULT_AMPLITUDE = -1,
        // BUG - EFFECT_CLICK = 0,
        EFFECT_DOUBLE_CLICK,
        EFFECT_TICK,
        EFFECT_HEAVY_CLICK = 5
    };
    Q_ENUM(VibrationEffect)

public slots:
    void vibrate(long milliseconds, VibrationEffect effect = AndroidVibrate::VibrationEffect::DEFAULT_AMPLITUDE);

private:
    QAndroidJniObject m_activity;
};

