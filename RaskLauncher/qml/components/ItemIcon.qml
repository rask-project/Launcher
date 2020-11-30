import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0

Item {
    id: itemIcon

    width: 60
    height: 100

    opacity: areaClick.pressed ? 0.5 : 1

    property string appName
    property string packageName
    property bool adaptative: false

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    Rectangle {
        id: rectangle
        width: itemIcon.width
        height: width

        //#4dffffff
        //#4d000000
        color: "#6dffffff"
        border.color: "#7dffffff"
        border.width: 1
        radius: 15

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                x: image.x
                y: image.y
                width: image.width
                height: image.height
                radius: itemIcon.adaptative ? 20 : 15
            }
        }
        Image {
            id: image
            width: parent.width * (itemIcon.adaptative ? 1.5 : 1)
            height: parent.height * (itemIcon.adaptative ? 1.5 : 1)
            cache: true
            anchors.centerIn: parent

            //source: "file:///home/marssola/.local/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png"
            source: "image://systemImage/" + itemIcon.packageName

            layer.enabled: true
            layer.effect: DropShadow {
                verticalOffset: 0
                horizontalOffset: 0
                color: "#6d000000"
                radius: 30
                samples: 61
                spread: 0.1
            }
        }
    }

    Label {
        width: parent.width
        height: 36

        anchors.top: rectangle.bottom

        text: itemIcon.appName
        font.pixelSize: 12
        color: "#fff"

        elide: Label.ElideRight
        wrapMode: Label.WordWrap
        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter

        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 2
            color: "#000000"
            radius: 8
            samples: 20
        }
    }

    MouseArea {
        id: areaClick
        anchors.fill: parent

        onClicked: RaskLauncher.launchApplication(itemIcon.packageName)
    }
}
