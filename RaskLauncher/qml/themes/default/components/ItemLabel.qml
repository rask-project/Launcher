import QtQuick 2.12
import QtQuick.Controls 2.12

Row {
    id: control

    width: parent.width
    height: control.item ? control.item.implicitHeight : 50

    property string label
    property Item item

    Item {
        width: control.width / 2
        height: control.height

        Label {
            width: parent.width
            height: parent.height

            text: control.label
            font.bold: true

            verticalAlignment: Label.AlignVCenter
            wrapMode: Label.WordWrap
            elide: Label.ElideRight
        }
    }

    Item {
        width: control.width / 2
        height: control.height

        data: control.item
    }
}
