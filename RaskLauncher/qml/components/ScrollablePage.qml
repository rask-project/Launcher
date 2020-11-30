import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    id: page

    default property alias content: pane.contentItem

    background: Rectangle {
        color: "transparent"
    }

    Flickable {
        anchors.fill: parent
        contentHeight: pane.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded

        Pane {
            id: pane
            width: parent.width
            padding: 0

            background: Rectangle {
                color: "transparent"
            }
        }
    }
}
