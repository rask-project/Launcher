import QtQuick 2.12
import QtQuick.Controls 2.12

Flickable {
    id: root

    property alias content: pane.contentItem

    Pane {
        id: pane
        width: parent.width
        padding: 0

        background: Rectangle {
            color: "transparent"
        }
    }

    ScrollIndicator.vertical: ScrollIndicator {}
}
