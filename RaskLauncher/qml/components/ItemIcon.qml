import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0

Item {
    id: itemIcon

    width: 70
    height: 120

    opacity: areaClick.pressed ? 0.5 : 1

    property string appName
    property string packageName
    property bool adaptative: false

    property int iconWidth: 60
    property int iconHeight: 60

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 5

        Column {
            id: column

            width: itemIcon.itemWidth
            spacing: 5

            Rectangle {
                id: rectangle
                width: itemIcon.iconWidth
                height: itemIcon.iconHeight
                radius: 15
                color: "#50000000"

                //color: "#60ffffff"
                anchors.horizontalCenter: parent.horizontalCenter

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
                        color: "#90ffffff"
                        radius: 5
                        samples: 11
                    }
                }

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        x: image.x
                        y: image.y
                        width: image.width
                        height: image.height
                        radius: rectangle.radius
                    }
                }
            }

            Label {
                width: parent.width
                height: 36

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
        }

        MouseArea {
            id: areaClick
            anchors.fill: parent

            onClicked: RaskLauncher.launchApplication(itemIcon.packageName)
        }
    }
}
