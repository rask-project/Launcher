import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0

Flickable {
    id: scrollGrid

    contentHeight: applicationFlow.height
    maximumFlickVelocity: height * 5

    property var onClicked: function (packageName) {}
    property var onPressAndHold: function (app) {}
    property AppActions actions
    property string title

    property int widthAvailable: width - leftMargin - rightMargin
    property var model: []
    property int iconSize: raskSettings.iconSize
    property int iconSpacing: raskSettings.iconSpacing

    property bool textNegative: false

    rebound: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: 500
            easing.type: Easing.OutBack
        }
    }

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
        }

        Item {
            width: applicationFlow.width - applicationFlow.leftPadding
                   - applicationFlow.rightPadding
            height: scrollGrid.iconSpacing
        }
    }
}
