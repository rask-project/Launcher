import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0
import "./themes"

ApplicationWindow {
    id: window

    width: 393
    height: 873
    visible: true

    title: qsTr("Rask Launcher")

    background: Rectangle {
        width: window.width
        height: window.height

        Image {
            anchors.fill: parent

            fillMode: Image.PreserveAspectCrop
            source: "image://systemImage/wallpaper"
        }
    }

    property bool activeScreen: Qt.application.state === Qt.ApplicationActive
    property bool isWindowActive: Qt.application.state === Qt.ApplicationActive
    property int dpi: Screen.pixelDensity * 25.4

    StackView {
        anchors.fill: parent

        initialItem: Default {
            id: themeDefault
        }
    }

    Component.onCompleted: RaskLauncher.retrievePackages()

    onActiveScreenChanged: if (activeScreen)
                               ScreenManager.updateScreenValues()
}
