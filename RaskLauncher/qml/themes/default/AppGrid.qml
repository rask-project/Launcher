import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0


/*
GridView {
    id: scrollGrid

    property var onClicked: function (packageName) {}
    property var onPressAndHold: function (app) {}
    property AppActions actions
    property string title

    property int iconSize: raskSettings.iconSize
    property int iconSpacing: raskSettings.iconSpacing
    property bool textNegative: false

    cellWidth: iconSize + iconSpacing

    delegate: Column {
        width: GridView.view.cellWidth
        height: width + 36
        spacing: 5

        Rectangle {
            id: iconBackground

            width: scrollGrid.iconSize
            height: width

            radius: raskSettings.iconRadius
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                width: parent.width * (modelData.adaptativeIcon ? 1.5 : 1)
                height: width

                source: "image://systemImage/" + modelData.packageName
                asynchronous: true
                anchors.centerIn: parent

                sourceSize.width: width
                sourceSize.height: height
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    x: iconBackground.x
                    y: iconBackground.y
                    width: iconBackground.width
                    height: iconBackground.height
                    radius: iconBackground.radius
                }
            }
        }

        Label {
            width: parent.width
            height: 36
            text: modelData.name

            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            font.pixelSize: 12
            color: RaskTheme.getColor(RaskTheme.White)
        }
    }
}
*/
Flickable {
    id: scrollGrid

    contentHeight: applicationFlow.height

    property var onClicked: function (packageName) {}
    property var onPressAndHold: function (app) {}
    property AppActions actions
    property string title

    property int widthAvailable: width - leftMargin - rightMargin
    property var model: []
    property int iconSize: raskSettings.iconSize
    property int iconSpacing: raskSettings.iconSpacing

    property bool textNegative: false

    Flow {
        id: applicationFlow

        width: parent.width
        topPadding: 15
        leftPadding: (scrollGrid.widthAvailable
                      % (scrollGrid.iconSize + scrollGrid.iconSpacing)) / 2
        rightPadding: leftPadding

        Repeater {
            id: repeater

            model: scrollGrid.model

            AppItem {
                id: appItem

                width: scrollGrid.iconSize + scrollGrid.iconSpacing
                iconSize: scrollGrid.iconSize
                textNegative: scrollGrid.textNegative

                applicationName: modelData.name
                packageName: modelData.packageName
                //icon: "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/" + packageName + ".svg"
                icon: "image://systemImage/" + packageName
                adaptativeIcon: modelData.adaptativeIcon

                click.onClicked: scrollGrid.onClicked(packageName)
                click.onPressAndHold: {
                    if (scrollGrid.actions) {
                        scrollGrid.actions.parent = appItem
                        scrollGrid.actions.modelData = modelData
                        scrollGrid.actions.visible = true

                        AndroidVibrate.vibrate(
                                    200, AndroidVibrate.EFFECT_HEAVY_CLICK)
                    }
                }
            }


            /*
            Column {
                width: scrollGrid.iconSize + scrollGrid.iconSpacing
                height: width + 36
                spacing: 5

                Rectangle {
                    id: iconBackground

                    width: scrollGrid.iconSize
                    height: width

                    radius: raskSettings.iconRadius
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        width: parent.width * (modelData.adaptativeIcon ? 1.5 : 1)
                        height: width

                        source: "image://systemImage/" + modelData.packageName
                        asynchronous: true
                        anchors.centerIn: parent

                        sourceSize.width: width
                        sourceSize.height: height
                    }

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            x: iconBackground.x
                            y: iconBackground.y
                            width: iconBackground.width
                            height: iconBackground.height
                            radius: iconBackground.radius
                        }
                    }
                }

                Label {
                    width: parent.width
                    height: 36
                    text: modelData.name

                    elide: Label.ElideRight
                    wrapMode: Label.WordWrap
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    font.pixelSize: 12
                    color: RaskTheme.getColor(RaskTheme.White)
                }
            }
            */
        }

        Item {
            width: applicationFlow.width - applicationFlow.leftPadding
                   - applicationFlow.rightPadding
            height: scrollGrid.iconSpacing
        }
    }
}
