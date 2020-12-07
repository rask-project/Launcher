import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

Item {
    id: dockItem

    property var shadderSource
    property var model: []

    Rectangle {
        id: dockRectangle

        width: parent.width * 0.9
        height: parent.height * 0.8

        anchors.horizontalCenter: parent.horizontalCenter
        radius: 20

        color: "#333"

        ListView {
            id: listHorizontalApps

            anchors.fill: parent
            orientation: Qt.Horizontal
            spacing: 5

            model: dockItem.model
            delegate: Item {
                width: height
                height: listHorizontalApps.height

                AppItem {
                    id: appItem

                    icon: modelData.icon
                    //icon: "image://systemImage/" + modelData.packageName
                    showAppName: false
                    anchors.centerIn: parent
                    scaleForClick: 1.2

                    click.onClicked: {
                        RaskLauncher.launchApplication(modelData.packageName)
                        AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
                    }
                }
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: dockRectangle.width
                height: dockRectangle.height
                radius: dockRectangle.radius
            }
        }

        FastBlur {
            id: fastBlur

            anchors.fill: parent
            radius: 100
            opacity: 0.3

            source: ShaderEffectSource {
                id: shader

                anchors.fill: parent
                sourceItem: dockItem.shadderSource
                sourceRect: Qt.rect(
                                dockItem.x + 10,
                                dockItem.y - (dockItem.height - dockRectangle.height) - 10,
                                dockRectangle.width, dockRectangle.height)
            }
        }
    }
}
