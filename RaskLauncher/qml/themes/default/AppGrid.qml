import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0

Flickable {
    id: scrollGrid

    contentHeight: applicationFlow.implicitHeight

    property var onClicked: function (packageName) {}
    property var onPressAndHold: function (app) {}
    property ListModel actionOptions

    property int widthAvailable: width - leftMargin - rightMargin
    property var model: []
    property int iconSize: 45
    property int iconSpacing: 25

    signal flickBeforeStart
    signal flickAfterEnd

    QtObject {
        id: flickData

        property int beforeHeight: -70
        property int afterHeight: 150
        property bool flickedStart: false
        property bool flickedEnd: false
    }

    onContentYChanged: {
        if (!flickData.flickedStart && atYBeginning
                && contentY < flickData.beforeHeight) {
            flickData.flickedStart = true
            flickAndHoldStart.running = true
            return
        }

        if (!flickData.flickedEnd && atYEnd
                && (contentY > flickData.afterHeight)) {
            flickData.flickedEnd = true
            flickAndHoldEnd.running = true
        }
    }

    Timer {
        id: flickAndHoldStart
        interval: 1000

        onTriggered: {
            if (scrollGrid.contentY <= flickData.beforeHeight) {
                scrollGrid.flickBeforeStart()
                AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
            }
        }
    }

    Timer {
        id: flickAndHoldEnd
        interval: 1000

        onTriggered: {
            if (scrollGrid.contentY >= flickData.afterHeight) {
                scrollGrid.flickAfterEnd()
                AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
            }
        }
    }

    onMovementEnded: {
        flickData.flickedStart = false
        flickData.flickedEnd = false
        flickAndHoldStart.running = false
        flickAndHoldEnd.running = false
    }

    children: [
        Item {
            id: itemSearch

            y: scrollGrid.contentY >= 0 ? -height - 30 : -height - scrollGrid.contentY - 30

            width: parent.width
            height: buttonSearchPage.height * 1.2

            Button {
                id: buttonSearchPage

                anchors.centerIn: parent
                flat: true

                icon.name: "search"
                text: qsTr("Search Apps")
            }
        },
        Item {
            y: (Screen.height > scrollGrid.contentHeight ? Screen.height : scrollGrid.contentHeight)
               + height - scrollGrid.contentY

            width: parent.width
            height: buttonHiddenApps.height * 1.2

            Button {
                id: buttonHiddenApps

                anchors.centerIn: parent
                flat: true

                icon.name: "visibility"
                text: qsTr("Hidden Apps")
            }
        }
    ]

    Flow {
        id: applicationFlow

        width: parent.width
        leftPadding: (scrollGrid.widthAvailable
                      % (scrollGrid.iconSize + scrollGrid.iconSpacing)) / 2
        rightPadding: leftPadding

        Repeater {
            id: repeater

            model: scrollGrid.model

            AppItem {
                width: scrollGrid.iconSize + scrollGrid.iconSpacing

                applicationName: modelData.name
                packageName: modelData.packageName
                icon: "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/"
                      + packageName + ".svg"
                //icon: "image://systemImage/" + packageName
                adaptativeIcon: modelData.adaptativeIcon

                click.onClicked: scrollGrid.onClicked(packageName)
                click.onPressAndHold: {
                    actions.visible = true
                    AndroidVibrate.vibrate(200,
                                           AndroidVibrate.EFFECT_HEAVY_CLICK)
                }

                AppActions {
                    id: actions

                    name: modelData.name
                    options: scrollGrid.actionOptions
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
