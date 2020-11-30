QT += qml quick quickcontrols2 svg

CONFIG += c++17

TARGET = RaskLauncher

SOURCES += \
        $$PWD/main.cpp \
        cpp/imageprovider.cpp \
        cpp/rasklauncher.cpp

RESOURCES += $$PWD/qml.qrc

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
        $$PWD/android/res/values/libs.xml

    OTHER_FILES += \
        $$PWD/android/src/com/QtRask/Launcher/*kt

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    ANDROID_ABIS = arm64-v8a
}

HEADERS += \
    cpp/imageprovider.h \
    cpp/rasklauncher.h \
    cpp/utilsJni.h

DISTFILES += \
    android/res/values/styles.xml \
    android/src/com/QtRask/Launcher/Application.kt \
    android/src/com/QtRask/Launcher/RaskLauncher.kt

contains(ANDROID_TARGET_ARCH,) {
    ANDROID_ABIS = \
        arm64-v8a
}
