import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0
import "./themes"

ApplicationWindow {
    id: window

    width: 393
    height: 873
    visible: true

    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
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

    Dialog {
        id: modal

        modal: true
        closePolicy: Popup.NoAutoClose

        parent: ApplicationWindow.contentItem
        width: 300
        height: 400
        anchors.centerIn: parent

        background: Rectangle {
            color: "#fff"

            FastBlur {
                id: fastBlur

                anchors.fill: modal.background
                radius: 60
                opacity: 0.5

                source: ShaderEffectSource {
                    anchors.fill: parent
                    sourceItem: ApplicationWindow.contentItem
                    sourceRect: Qt.rect(modal.x, modal.y, modal.width,
                                        modal.height)
                }
            }
        }
    }

    Component.onCompleted: RaskLauncher.retrievePackages()
}
