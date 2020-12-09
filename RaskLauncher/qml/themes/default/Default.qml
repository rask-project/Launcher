import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Page {
    id: page

    padding: 30
    leftPadding: 10
    rightPadding: 10

    property alias applications: appGrid.model

    background: Item {}

    //background: Rectangle {
    //    Image {
    //        anchors.fill: parent
    //        source: "file:///home/marssola/Pictures/P00613-120151.jpg"
    //        fillMode: Image.PreserveAspectCrop
    //    }
    //}
    AppGrid {
        id: appGrid

        width: parent.width
        height: parent.height
    }

    footer: AppDock {
        visible: model.length > 0
        width: parent.width
        height: 100

        anchors.bottom: parent.bottom
        shadderSource: appGrid
        //model: page.applications.splice(10, 10)
    }
}
