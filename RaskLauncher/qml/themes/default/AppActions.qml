import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import "components"

Popup {
    id: control

    width: parent.width > 200 ? parent.width : 200
    padding: 0
    bottomPadding: 15
    margins: 0
    horizontalPadding: 0

    modal: false
    clip: true

    property string name
    property ListModel options

    Column {
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

    background: Rectangle {
        color: "#cf333333"

        radius: 15

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                x: control.x
                y: control.y
                width: control.width
                height: control.height
                radius: control.background.radius
            }
        }
    }
}
