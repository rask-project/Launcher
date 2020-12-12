import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import QtRask.Launcher 1.0

Item {
    id: root

    property Flickable flickableItem
    property Item contentTop
    property Item contentBottom: Item
    readonly property alias flickData: flickData

    signal triggerToTop
    signal triggerToBottom

    Item {
        id: itemTop

        y: root.flickableItem.contentY >= 0 ? -height - 30 : -height
                                              - root.flickableItem.contentY - 30

        parent: root.parent
        width: parent.width
        height: root.contentTop ? root.contentTop.height * 1.2 : 0

        data: [root.contentTop]
    }

    Item {
        id: itemBottom

        y: (Screen.height
            > root.flickableItem.contentHeight ? Screen.height : root.flickableItem.contentHeight)
           + height - root.flickableItem.contentY

        parent: root.parent
        width: parent.width
        height: root.contentBottom ? root.contentBottom.height * 1.2 : 0

        data: [root.contentBottom]
    }

    QtObject {
        id: flickData

        property int beforeHeight: -70
        property int afterHeight: 150
        property bool flickedStart: false
        property bool flickedEnd: false
    }

    Timer {
        id: flickAndHoldStart
        interval: 1000

        onTriggered: root.triggerToTop()
    }

    Timer {
        id: flickAndHoldEnd
        interval: 1000

        onTriggered: root.triggerToBottom()
    }

    Connections {
        target: root.flickableItem

        function onContentYChanged() {
            if (!flickData.flickedStart && target.atYBeginning
                    && target.contentY < flickData.beforeHeight) {
                flickData.flickedStart = true
                flickAndHoldStart.running = true
                return
            }

            if (!flickData.flickedEnd && target.atYEnd
                    && (target.contentY > flickData.afterHeight)) {
                flickData.flickedEnd = true
                flickAndHoldEnd.running = true
            }
        }

        function onMovementEnded() {
            flickData.flickedStart = false
            flickData.flickedEnd = false
            flickAndHoldStart.running = false
            flickAndHoldEnd.running = false
        }
    }
}
