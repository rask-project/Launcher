import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

Item {
    id: dockItem

    property var shadderSource
    property var model: []
    onModelChanged: listHorizontalApps.interactive = true

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
                id: item

                width: height
                height: listHorizontalApps.height
                z: 1

                property int positionStarted: 0
                property int positionEnded: 0
                property int positionsMoved: Math.floor(
                                                 item.positionEnded
                                                 - item.positionStarted) / item.width
                property int newPosition: index + item.positionsMoved
                property bool held: false
                property bool moved: item.positionEnded !== item.positionStarted

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

                    click.pressAndHoldInterval: 500

                    click.drag.axis: Drag.XAxis

                    click.onClicked: {
                        RaskLauncher.launchApplication(packageName)
                        AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
                    }

                    click.onPressAndHold: function () {}

                    click.onPositionChanged: item.positionEnded = item.x

                    click.onReleased: {
                        if (listHorizontalApps.interactive)
                            return

                        if (Math.abs(item.positionsMoved) < 1 && item.held) {
                            item.x = item.positionStarted
                        } else {
                            if (item.held) {
                                Applications.reorganizeDock(
                                            move(dockItem.model, index,
                                                 item.newPosition))
                            }
                        }

                        item.z = 1
                        item.opacity = 1
                        appItem.click.drag.target = null
                        item.held = false
                    }

                    Timer {
                        id: longPressTimer

                        interval: 500
                        repeat: false
                        running: appItem.click.pressed

                        onTriggered: {
                            item.positionEnded = item.x
                            item.z = 3
                            item.positionStarted = item.x

                            listHorizontalApps.interactive = false
                            appItem.click.drag.target = item
                            item.opacity = 0.5
                            item.held = true

                            AndroidVibrate.vibrate(
                                        50, AndroidVibrate.EFFECT_HEAVY_CLICK)
                        }
                    }

                    Timer {
                        id: longLongPressTimer

                        interval: 1300
                        repeat: false
                        running: appItem.click.pressed && !item.moved

                        onTriggered: {
                            actions.visible = true
                            AndroidVibrate.vibrate(
                                        200, AndroidVibrate.EFFECT_HEAVY_CLICK)
                        }
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

    function move(arr, old_index, new_index) {
        while (old_index < 0) {
            old_index += arr.length
        }
        while (new_index < 0) {
            new_index += arr.length
        }
        if (new_index >= arr.length) {
            var k = new_index - arr.length
            while ((k--) + 1) {
                arr.push(undefined)
            }
        }
        arr.splice(new_index, 0, arr.splice(old_index, 1)[0])
        return arr
    }
}
