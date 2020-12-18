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

        readonly property int maxWidth: parent.width * 0.9
        readonly property int implicitItemsWidth: listHorizontalApps.model.length
                                                  * (raskSettings.iconSize
                                                     + (raskSettings.iconSize * 1.4
                                                        - raskSettings.iconSize))

        width: dockRectangle.maxWidth > dockRectangle.implicitItemsWidth ? dockRectangle.implicitItemsWidth : dockRectangle.maxWidth
        height: raskSettings.iconSize * 1.4

        anchors.horizontalCenter: parent.horizontalCenter
        radius: raskSettings.iconRadius

        color: RaskTheme.dockBackground

        ListView {
            id: listHorizontalApps
            z: 3

            anchors.fill: parent
            orientation: Qt.Horizontal
            spacing: 0

            model: dockItem.model
            delegate: Item {
                width: height
                height: listHorizontalApps.height

                AppItem {
                    id: appItem

                    width: raskSettings.iconSize
                    iconSize: raskSettings.iconSize

                    showAppName: false
                    applicationName: modelData.name
                    packageName: modelData.packageName
                    adaptativeIcon: modelData.adaptativeIcon
                    //icon: "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/" + packageName + ".svg"
                    icon: "image://systemImage/" + packageName

                    anchors.centerIn: parent
                    scaleForClick: 1.2

                    click.onClicked: {
                        RaskLauncher.launchApplication(packageName)
                        AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
                    }

                    click.onPressAndHold: {
                        actions.visible = true
                        AndroidVibrate.vibrate(
                                    200, AndroidVibrate.EFFECT_HEAVY_CLICK)
                    }

                    AppActions {
                        id: actions

                        name: appItem.applicationName
                        options: ListModel {
                            ListElement {
                                label: qsTr("Remove from Dock")
                                iconName: "bookmark"

                                property var func: function () {
                                    Applications.removeFromDock(
                                                appItem.packageName)
                                }
                            }
                        }
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
            z: 2

            source: ShaderEffectSource {
                id: shader

                anchors.fill: parent
                sourceItem: dockItem.shadderSource
                sourceRect: Qt.rect(
                                dockItem.x + (dockItem.width - dockRectangle.width) / 2,
                                dockItem.y - raskSettings.padding,
                                dockRectangle.width, dockRectangle.height)
            }
        }
    }
}
