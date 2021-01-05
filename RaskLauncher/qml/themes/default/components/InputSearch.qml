import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.15

import QtRask.Launcher 1.0

T.TextField {
    id: control

    property color backgroundColor: RaskTheme.inputBackground

    height: 50

    topPadding: 8
    bottomPadding: 8
    leftPadding: 30
    rightPadding: 30

    selectionColor: Qt.lighter(control.backgroundColor)
    selectedTextColor: control.color
    verticalAlignment: TextInput.AlignVCenter
    selectByMouse: true

    inputMethodHints: Qt.ImhSensitiveData

    PlaceholderText {
        id: placeholder

        text: control.placeholderText
        font: control.font
        //color: control.placeholderColor
        anchors.centerIn: control
        visible: !control.length && !control.preeditText
                 && (!control.activeFocus
                     || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
        opacity: 0.6
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 50
        color: control.backgroundColor
    }
}
