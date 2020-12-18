import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0

import QtRask.Launcher 1.0
import "./themes/default"

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
    property int dpi: Screen.pixelDensity * 25.4

    Settings {
        id: raskSettings

        fileName: "rask"
        property int padding: 50
        property int leftPadding: 10
        property int rightPadding: 10

        property int iconSize: 50
        property int iconSpacing: 20
        property int iconRadius: 15

        property int theme: Material.System
        onThemeChanged: RaskTheme.theme = raskSettings.theme
    }

    StackView {
        anchors.fill: parent

        initialItem: Default {
            id: themeDefault

            applications: Applications.list
            applicationsHidden: Applications.hidden
        }
    }

    Material.theme: RaskTheme.theme
    Material.accent: Material.Grey

    Component.onCompleted: {
        RaskLauncher.retrievePackages()
    }

    onActiveScreenChanged: {
        if (activeScreen)
            RaskLauncher.getSystemResources()
    }
}
