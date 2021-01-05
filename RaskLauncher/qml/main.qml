import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
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

    background: Item {}
    color: "transparent"

    property bool activeScreen: Qt.application.state === Qt.ApplicationActive

    Settings {
        id: raskSettings

        property int padding: 20
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
        raskSettings.padding = 20
        raskSettings.leftPadding = 10
        raskSettings.rightPadding = 10
    }

    onActiveScreenChanged: {
        if (activeScreen)
            RaskLauncher.getSystemResources()
    }
}
