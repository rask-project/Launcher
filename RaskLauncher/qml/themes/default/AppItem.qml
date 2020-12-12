import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Item {
    id: root

    property string applicationName
    property string packageName
    property string icon
    property int iconSize: 60
    property bool adaptativeIcon

    property bool showAppName: true
    property alias click: areaClick
    property double scaleForClick: 1.5

    width: 60
    height: width + (root.showAppName ? 36 : 0)

    Column {
        anchors.fill: parent

        Rectangle {
            id: iconGlass

            width: root.iconSize * 0.85
            height: width
            z: 2

            anchors.horizontalCenter: parent.horizontalCenter

            color: "#8d333333"
            border.color: "#8d222222"
            border.width: 1
            radius: 15

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 0
                radius: 3
                samples: 7
                color: "#999"
                opacity: 0.2
            }

            scale: areaClick.pressed ? root.scaleForClick : 1
            Behavior on scale {
                NumberAnimation {
                    duration: 200
                }
            }

            Rectangle {
                id: iconBackground

                width: parent.width
                height: width
                z: 3

                color: "transparent"
                anchors.centerIn: parent

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        x: iconBackground.x
                        y: iconBackground.y
                        width: iconBackground.width
                        height: iconBackground.height
                        radius: iconGlass.radius
                    }
                }

                Image {
                    width: parent.width * (root.adaptativeIcon ? 1.5 : 1)
                    height: width

                    asynchronous: true
                    anchors.centerIn: parent

                    sourceSize.width: width
                    sourceSize.height: height
                    source: root.icon

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 4
                        samples: 9
                        color: "#ccc"
                    }
                }
            }

            Rectangle {
                visible: areaClick.pressed
                opacity: visible ? 1 : 0
                anchors.fill: parent
                z: 4

                radius: parent.radius
                color: "#4d000000"

                Behavior on opacity {
                    NumberAnimation {
                        duration: 50
                    }
                }
            }

            MouseArea {
                id: areaClick
                anchors.fill: parent
            }
        }

        Label {
            visible: root.showAppName

            width: parent.width
            height: 36
            z: 1

            text: root.applicationName
            font.pixelSize: 12
            color: "#fff"

            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            layer.enabled: true
            layer.effect: DropShadow {
                verticalOffset: 0
                color: "#000000"
                radius: 10
                samples: 32
            }
        }
    }
}
