#include "screenmanager.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#endif
#include <QDebug>

ScreenManager::ScreenManager(QObject *parent):
    QObject(parent),
    m_statusBarHeight(0),
    m_navigationBarHeight(0),
    m_navigationBarHeightLandscape(0)
{
    setStatusBarHeight(getResourceSize(QStringLiteral("status_bar_height")));
    setNavigationBarHeight(getResourceSize(QStringLiteral("navigation_bar_height")));
    setNavigationBarHeightLandscape(getResourceSize(QStringLiteral("navigation_bar_height_landscape")));

    updateScreenValues();
}

void ScreenManager::updateScreenValues()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");

    QAndroidJniObject windowManager = activity.callObjectMethod("getWindowManager", "()Landroid/view/WindowManager;");
    QAndroidJniObject display = windowManager.callObjectMethod("getDefaultDisplay", "()Landroid/view/Display;");

    QAndroidJniObject realSize = QAndroidJniObject("android/graphics/Point");
    display.callMethod<void>("getRealSize", "(Landroid/graphics/Point;)V", realSize.object());

    QAndroidJniObject displayFrame = QAndroidJniObject("android/graphics/Rect");
    QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
    QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
    QAndroidJniObject rootView = view.callObjectMethod("getRootView", "()Landroid/view/View;");
    rootView.callMethod<void>("getWindowVisibleDisplayFrame", "(Landroid/graphics/Rect;)V", displayFrame.object());

    int y = static_cast<int>(realSize.getField<jint>("y"));
    int height = static_cast<int>(realSize.getField<jint>("height"));

    qDebug() << "ScreenManager" << y << height << (y - height - m_statusBarHeight == 0);
#endif
}

int ScreenManager::getNavigationBarHeightLandscape() const
{
    return m_navigationBarHeightLandscape;
}

void ScreenManager::setNavigationBarHeightLandscape(int navigationBarHeightLandscape)
{
    if (m_navigationBarHeightLandscape == navigationBarHeightLandscape)
        return;

    m_navigationBarHeightLandscape = navigationBarHeightLandscape;
    emit navigationBarHeightLandscapeChanged();
}

int ScreenManager::getNavigationBarHeight() const
{
    return m_navigationBarHeight;
}

void ScreenManager::setNavigationBarHeight(int navigationBarHeight)
{
    if (m_navigationBarHeight == navigationBarHeight)
        return;

    m_navigationBarHeight = navigationBarHeight;
    emit navigationBarHeightChanged();
}

int ScreenManager::getStatusBarHeight() const
{
    return m_statusBarHeight;
}

void ScreenManager::setStatusBarHeight(int statusBarHeight)
{
    if (m_statusBarHeight == statusBarHeight)
        return;

    m_statusBarHeight = statusBarHeight;
    emit statusBarHeightChanged();
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

    jint size = resources.callMethod<jint>("getDimensionPixelSize",
                                           "(I)I", identifier);

    qDebug() << "Resource" << value << size;
    return size;
#endif
}
