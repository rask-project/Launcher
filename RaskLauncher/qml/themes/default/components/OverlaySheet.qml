import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Drawer {
    id: control

    default property alias content: pane.contentItem

    width: parent.width
    height: parent.height

    padding: 0
    margins: 0
    horizontalPadding: 0

    edge: Qt.BottomEdge
    modal: true

    Flickable {
        id: flickable

        contentHeight: pane.implicitHeight + anchors.topMargin + anchors.bottomMargin
        anchors.fill: parent
        anchors.topMargin: 30
        anchors.bottomMargin: 30

        Pane {
            id: pane

            width: parent.width
            background: Item {}
            padding: 0
        }
    }

    background: Item {}
    Overlay.modal: BlurOverlay {}
}
