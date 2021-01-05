QT += qml quick quickcontrols2 svg

CONFIG += c++17

TARGET = RaskLauncher

SOURCES += \
        $$PWD/main.cpp \
        cpp/androidvibrate.cpp \
        cpp/applications.cpp \
        cpp/imageprovider.cpp \
        cpp/jsonabstractlistmodel.cpp \
        cpp/rasklauncher.cpp \
        cpp/rasktheme.cpp \
        cpp/screenmanager.cpp

RESOURCES += $$PWD/qml.qrc \
             $$PWD/icons/material-round.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

android {
    QT += androidextras

    DISTFILES += \
        $$PWD/android/AndroidManifest.xml \
        $$PWD/android/build.gradle \
        $$PWD/android/gradle/wrapper/gradle-wrapper.jar \
        $$PWD/android/gradle/wrapper/gradle-wrapper.properties \
        $$PWD/android/gradlew \
        $$PWD/android/gradlew.bat \
        $$PWD/android/res/values/libs.xml \
        $$PWD/android/res/values/screen_data.xml \
        $$PWD/android/res/values/styles.xml \
        $$PWD/android/src/com/QtRask/Launcher/Application.kt \
        $$PWD/android/src/com/QtRask/Launcher/RaskLauncher.kt
    OTHER_FILES += \
        $$PWD/android/src/com/QtRask/Launcher/*kt

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    ANDROID_ABIS = arm64-v8a
} else {
    RESOURCES +=  \
                $$PWD/icons/applications.qrc
}

HEADERS += \
    cpp/androidvibrate.h \
    cpp/applications.h \
    cpp/imageprovider.h \
    cpp/jsonabstractlistmodel.h \
    cpp/rasklauncher.h \
    cpp/rasktheme.h \
    cpp/screenmanager.h \
    cpp/singleton.h \
    cpp/utilsJni.h


contains(ANDROID_TARGET_ARCH,) {
    ANDROID_ABIS = \
        arm64-v8a \
        x86_64
}

ANDROID_ABIS = arm64-v8a x86_64

DISTFILES += \
    android/src/com/QtRask/Launcher/NotificationBroadcast.kt
