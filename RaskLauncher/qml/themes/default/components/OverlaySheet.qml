import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Drawer {
    id: control

    width: parent.width
    height: parent.height

    padding: 0
    margins: 0
    topPadding: 50
    horizontalPadding: 0

    edge: Qt.BottomEdge
    modal: true

    background: Item {}
    Overlay.modal: BlurOverlay {}
}
