import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property Flickable flickableItem
    property ItemOptionFlickable contentTop
    property ItemOptionFlickable contentBottom

    signal triggerToTop
    signal triggerToBottom

    readonly property int limitTrigger: 100

    Item {
        id: itemTop

        y: root.flickableItem.contentY >= 0 ? -height * 2 : -height * 2
                                              - root.flickableItem.contentY

        property ItemOptionFlickable selectedOption

        onYChanged: {
            if (!root.flickableItem.atYBeginning)
                return

            const pos = y + columnTop.height
            if (pos >= root.limitTrigger) {
                root.contentTop.focus = true
                return
            }
            root.contentTop.focus = false
        }

        parent: root.parent
        width: parent.width
        height: columnTop.height

        Column {
            id: columnTop

            width: parent.width
            data: root.contentTop
        }
    }

    Item {
        id: itemBottom

        y: (Window.height > root.flickableItem.contentHeight
            + 60 ? Window.height : root.flickableItem.contentHeight + 60)
           - root.flickableItem.contentY

        onYChanged: {
            if (!root.flickableItem.atYEnd)
                return

            const contentHeight = root.flickableItem.contentHeight
            let pos
            if (contentHeight > Window.height) {
                pos = contentHeight - root.contentBottom.height - y
            } else {
                pos = (Window.height - y)
            }

            if (pos >= root.limitTrigger) {
                root.contentBottom.focus = true
                return
            }
            root.contentBottom.focus = false
        }

        parent: root.parent
        width: parent.width
        height: columnBottom.height

        Column {
            id: columnBottom

            width: parent.width
            data: root.contentBottom
        }
    }
}
