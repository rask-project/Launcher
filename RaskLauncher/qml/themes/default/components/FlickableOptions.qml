import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property Flickable flickableItem
    property list<ItemOptionFlickable> contentTop
    property list<ItemOptionFlickable> contentBottom

    signal triggerToTop
    signal triggerToBottom

    Item {
        id: itemTop

        y: root.flickableItem.contentY >= 0 ? -height * 2 : -height * 2
                                              - root.flickableItem.contentY

        property ItemOptionFlickable selectedOption

        onYChanged: {
            const pos = y + columnTop.height
            const itemHeight = columnTop.height / columnTop.data.length
            const posItem = parseInt(pos / itemHeight)
            const totalItems = columnTop.data.length

            for (var i = 0; i < totalItems; ++i)
                columnTop.data[i].focus = false

            if (posItem >= 0 && posItem <= totalItems - 1) {
                const k = totalItems - posItem - 1
                if (pos >= 0 && pos <= (itemHeight * posItem) + itemHeight) {
                    columnTop.data[k].focus = true
                }
            }
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

        y: (Window.height
            > root.flickableItem.contentHeight ? Window.height : root.flickableItem.contentHeight
                                                 + 60) - root.flickableItem.contentY

        onYChanged: {
            const contentY = root.flickableItem.contentY
            const contentHeight = root.flickableItem.contentHeight
            const itemHeight = columnBottom.height / columnBottom.data.length
            const totalItems = columnBottom.data.length

            let pos
            let posItem

            if (contentHeight > Window.height) {
                pos = (contentHeight + 120) - Window.height
                posItem = parseInt((contentY - pos - itemHeight) / itemHeight)
            } else {
                pos = contentY - itemHeight + (contentHeight === Window.height ? -60 : 0)
                posItem = parseInt(pos / itemHeight) - 1
            }

            for (var i = 0; i < totalItems; ++i)
                columnBottom.data[i].focus = false

            if (contentY < pos || posItem < 0)
                return

            if (posItem >= 0 && posItem <= totalItems - 1) {
                columnBottom.data[posItem].focus = true
            }
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
