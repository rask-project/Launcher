#include "screenmanager.h"
#include "rasktheme.h"
#include "singleton.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#endif
#include <QColor>
#include <QDebug>

constexpr auto FLAG_TRANSLUCENT_STATUS = 0x04000000;
constexpr auto FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS = 0x80000000;
constexpr auto SYSTEM_UI_FLAG_LIGHT_STATUS_BAR = 0x00002000;

const auto colorBar = QColor::fromRgbF(0xFF, 0xFF, 0xFF, 0.80).rgba();
const auto transparentColorBar = QColor::fromRgbF(0xFF, 0xFF, 0xFF, 0x0).rgba();

ScreenManager::ScreenManager(QObject *parent):
    QObject(parent),
    m_density(0),
    m_statusBarHeight(0),
    m_navigationBarHeight(0),
    m_navigationBarHeightLandscape(0),
    m_navigationBarVisible(false)
{
    setDensity(getDensity());
    setStatusBarHeight(getResourceSize(QStringLiteral("status_bar_height")));
    setNavigationBarHeight(getResourceSize(QStringLiteral("navigation_bar_height")));
    setNavigationBarHeightLandscape(getResourceSize(QStringLiteral("navigation_bar_height_landscape")));

    qDebug() << "Screen Values" << m_statusBarHeight << m_navigationBarHeight << m_navigationBarHeightLandscape;
    updateScreenValues();

    statusBarColor(false);
    navBarColor(true);
}

void ScreenManager::updateScreenValues()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");
    QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

    QAndroidJniObject windowManager = activity.callObjectMethod("getWindowManager", "()Landroid/view/WindowManager;");
    QAndroidJniObject display = windowManager.callObjectMethod("getDefaultDisplay", "()Landroid/view/Display;");

    QAndroidJniObject realSize = QAndroidJniObject("android/graphics/Point");
    display.callMethod<void>("getRealSize", "(Landroid/graphics/Point;)V", realSize.object());

    QAndroidJniObject displayFrame = QAndroidJniObject("android/graphics/Rect");
    QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
    QAndroidJniObject rootView = view.callObjectMethod("getRootView", "()Landroid/view/View;");
    rootView.callMethod<void>("getWindowVisibleDisplayFrame", "(Landroid/graphics/Rect;)V", displayFrame.object());

    int y = std::floor(static_cast<int>(realSize.getField<jint>("y")) / m_density);
    int height = std::floor(static_cast<int>(displayFrame.callMethod<jint>("height")) / m_density);

    if ((y - height - m_statusBarHeight) == 0)
        setNavigationBarVisible(false);
    else
        setNavigationBarVisible(true);
#endif
}

void ScreenManager::statusBarColor(bool value)
{
#ifdef Q_OS_ANDROID
    if (QtAndroid::androidSdkVersion() < 21)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        const auto window = getAndroidWindow();
        window.callMethod<void>("setStatusBarColor", "(I)V", value ? colorBar : transparentColorBar);
    });
#else
#endif
    Q_UNUSED(value)
}

void ScreenManager::navBarColor(bool value)
{
#ifdef Q_OS_ANDROID
    if (QtAndroid::androidSdkVersion() < 21)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        const auto window = getAndroidWindow();
        window.callMethod<void>("setNavigationBarColor", "(I)V", value ? colorBar : transparentColorBar);
    });
#else
#endif
    Q_UNUSED(value)
}

#ifdef Q_OS_ANDROID
QAndroidJniObject ScreenManager::getAndroidWindow()
{
    QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
    window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
    window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (Singleton<RaskTheme>::getInstanceQML().theme() == RaskTheme::Theme::Light)
            visibility |= SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
    });

    return window;
}
#endif

bool ScreenManager::getNavigationBarVisible() const
{
    return m_navigationBarVisible;
}

void ScreenManager::setNavigationBarVisible(bool navigationBarVisible)
{
    m_navigationBarVisible = navigationBarVisible;
    emit navigationBarVisibleChanged();
}

float ScreenManager::getDensity() const
{
    return m_density;
}

void ScreenManager::setDensity(float density)
{
    m_density = density;
}

int ScreenManager::getNavigationBarHeightLandscape() const
{
    return m_navigationBarHeightLandscape;
}

void ScreenManager::setNavigationBarHeightLandscape(int value)
{
#ifdef Q_OS_ANDROID
    int navigationBarHeightLandscape = static_cast<int>(std::floor(value / m_density));
    if (m_navigationBarHeightLandscape == navigationBarHeightLandscape)
        return;

    m_navigationBarHeightLandscape = navigationBarHeightLandscape;
    emit navigationBarHeightLandscapeChanged();
#else
    m_navigationBarHeightLandscape = value;
    emit navigationBarHeightLandscapeChanged();
#endif
}

int ScreenManager::getNavigationBarHeight() const
{
    return m_navigationBarHeight;
}

void ScreenManager::setNavigationBarHeight(int value)
{
#ifdef Q_OS_ANDROID
    int navigationBarHeight = static_cast<int>(std::floor(value / m_density));
    if (m_navigationBarHeight == navigationBarHeight)
        return;

    m_navigationBarHeight = navigationBarHeight;
    emit navigationBarHeightChanged();
#else
    m_navigationBarHeight = value;
    emit navigationBarHeightChanged();
#endif
}

int ScreenManager::getStatusBarHeight() const
{
    return m_statusBarHeight;
}

void ScreenManager::setStatusBarHeight(int value)
{
#ifdef Q_OS_ANDROID
    int statusBarHeight = static_cast<int>(std::floor(value / m_density));
    if (m_statusBarHeight == statusBarHeight)
        return;

    m_statusBarHeight = statusBarHeight;
    emit statusBarHeightChanged();
#else
    m_statusBarHeight = value;
    emit statusBarHeightChanged();
#endif
}

int ScreenManager::getResourceSize(const QString &value)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");
    QAndroidJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");

    QAndroidJniObject name = QAndroidJniObject::fromString(value);
    QAndroidJniObject defType = QAndroidJniObject::fromString("dimen");
    QAndroidJniObject defPackage = QAndroidJniObject::fromString("android");

    jint identifier = resources.callMethod<jint>("getIdentifier",
                                                 "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
                                                 name.object<jstring>(),
                                                 defType.object<jstring>(),
                                                 defPackage.object<jstring>());

    jint size = resources.callMethod<jint>("getDimensionPixelSize", "(I)I", identifier);

    qDebug() << "Resource" << value << size;
    return size;
#else
    Q_UNUSED(value)
    return 0;
#endif
}

float ScreenManager::getDensity()
{
    float d = 0;
#ifdef Q_OS_ANDROID
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");
    QAndroidJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
    QAndroidJniObject displayMetrics = resources.callObjectMethod("getDisplayMetrics", "()Landroid/util/DisplayMetrics;");
    jfloat density = displayMetrics.getField<jfloat>("density");
    d = density;
#endif
    return d;
}
