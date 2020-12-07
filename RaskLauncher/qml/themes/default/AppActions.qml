import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Popup {
    id: control

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    width: parent.width > 300 ? parent.width : 300
    padding: 0
    margins: 0
    horizontalPadding: 0
    modal: true

    property string name
    property ListModel options

    contentItem: Column {
        width: control.width
        padding: 0

        Label {
            width: parent.width
            height: 64
            text: control.name

            font.bold: true
            font.pixelSize: 12
            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        Repeater {
            model: control.options

            ItemDelegate {
                width: parent.width < 300 ? parent.width : 300
                anchors.horizontalCenter: parent.horizontalCenter

                text: label
                icon.name: iconName

                onClicked: {
                    control.visible = false
                    if (typeof func === "function")
                        func()
                }
            }
        }
    }

    background: Item {}

    Overlay.modal: Rectangle {
        id: overlay
        width: control.parent.width
        height: control.parent.height

        color: "#333"

        FastBlur {
            id: fastBlur

            anchors.fill: parent
            radius: 100
            opacity: 0.7

            source: ShaderEffectSource {
                id: shader
                anchors.fill: parent
                sourceItem: ApplicationWindow.contentItem
                sourceRect: Qt.rect(overlay.x, overlay.y, overlay.width,
                                    overlay.height)
            }
        }
    }
}
