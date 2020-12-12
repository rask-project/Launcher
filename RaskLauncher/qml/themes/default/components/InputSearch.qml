import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls.impl 2.15
import QtQuick.Layouts 1.15

T.TextField {
    id: control

    property color backgroundColor: "#af333333"
    property color textColor: "#ffffff"
    property color placeholderColor: Qt.rgba(control.textColor.r,
                                             control.textColor.g,
                                             control.textColor.b, 0.4)

    height: 50

    topPadding: 8
    bottomPadding: 8
    leftPadding: 30
    rightPadding: 30

    selectionColor: Qt.lighter(control.backgroundColor)
    selectedTextColor: control.placeholderColor
    verticalAlignment: TextInput.AlignVCenter
    selectByMouse: true

    inputMethodHints: Qt.ImhSensitiveData

    color: control.textColor

    PlaceholderText {
        id: placeholder

        text: control.placeholderText
        font: control.font
        color: control.placeholderColor
        anchors.centerIn: control
        visible: !control.length && !control.preeditText
                 && (!control.activeFocus
                     || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 50
        color: control.backgroundColor
    }
}
