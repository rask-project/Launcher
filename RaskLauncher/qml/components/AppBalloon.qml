import QtQuick 2.12
import QtQuick.Controls 2.12

ToolTip {
    id: control

    padding: 0
    margins: 0

    property list<Item> options

    contentItem: Column {
        width: control.implicitWidth
        data: control.options
    }
}
