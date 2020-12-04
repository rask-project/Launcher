import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: control

    width: 300
    height: 100

    anchors.bottom: parent.bottom

    //TextField {
    //    id: field
    //    width: parent.width < 350 ? parent.width : 350
    //    anchors.horizontalCenter: parent.horizontalCenter
    //    padding: 10
    //    bottomPadding: padding
    //    topPadding: padding
    //    background: Rectangle {
    //        color: "#333"
    //        radius: 30
    //    }
    //}
    FastBlur {
        anchors.fill: parent
        radius: 10

        source: ShaderEffectSource {
            id: shader

            anchors.fill: parent

            sourceItem: ApplicationWindow.contentItem
            sourceRect: Qt.rect(dockItem.x, dockItem.y, control.width,
                                control.height)
            onSourceRectChanged: console.log(sourceRect)
        }
    }
}
