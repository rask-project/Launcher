import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

Item {
    id: appItem

    width: 60
    height: 100

    property string appName
    property string packageName
    property bool adaptative: false

    property alias click: areaClick

    Rectangle {
        id: rectangle
        width: appItem.width * 0.9
        height: width
        z: 2

        //#4dffffff
        //#4d000000
        color: "#4bFFFFFF"
        border.color: "#6dffffff"
        border.width: 1
        radius: 10

        scale: areaClick.pressed ? 1.5 : 1
        Behavior on scale {
            NumberAnimation {
                duration: 200
            }
        }

        layer.enabled: !appItem.adaptative
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 5
            samples: 11
            color: "#999"
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    x: rectangle.x
                    y: rectangle.y
                    width: rectangle.width
                    height: rectangle.height
                    radius: rectangle.radius
                }
            }

            Image {
                id: image
                width: parent.width * (appItem.adaptative ? 1.5 : 1)
                height: parent.height * (appItem.adaptative ? 1.5 : 1)
                cache: true
                anchors.centerIn: parent

                sourceSize.width: image.width
                sourceSize.height: image.height

                //source: "file:///home/marssola/.local/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png"
                source: "image://systemImage/" + appItem.packageName

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 1
                    samples: 3
                    color: "#999"
                    opacity: 0.2
                }
            }
        }

        Rectangle {
            visible: areaClick.pressed
            opacity: visible ? 1 : 0
            anchors.fill: parent
            z: 3

            radius: parent.radius
            color: "#4d000000"

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }
    }

    Label {
        width: parent.width
        height: 36
        z: 1

        anchors.top: rectangle.bottom

        text: appItem.appName
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
    }
}
