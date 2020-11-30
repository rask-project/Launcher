import QtQuick 2.12
import QtQuick.Controls 2.12

import QtRask.Launcher 1.0
import "./themes"

ApplicationWindow {
    id: window

    width: 393
    height: 873
    visible: true

    //flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
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

    StackView {
        anchors.fill: parent
        initialItem: Default {
            id: themeDefault
        }
    }

    Component.onCompleted: RaskLauncher.retrievePackages()
}
