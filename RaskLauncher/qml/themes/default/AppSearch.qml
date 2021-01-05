import QtQuick 2.12
import QtQuick.Layouts 1.15

import QtRask.Launcher 1.0
import "./components"

OverlaySheet {
    id: control

    edge: Qt.TopEdge

    ColumnLayout {
        width: parent.width
        height: parent.height
        spacing: 15

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: inputSearch.height * 1.2

            InputSearch {
                id: inputSearch

                width: parent.width > 400 ? 400 : parent.width * 0.9
                anchors.centerIn: parent
                placeholderText: qsTr("Type to search")
            }
        }

        AppGrid {

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            textNegative: RaskTheme.theme === RaskTheme.Light
            model: inputSearch.text.length === 0 ? [] : Applications.searchList.filter(
                                                       function (app) {
                                                           return app["name"].toLowerCase(
                                                                       ).match(
                                                                       inputSearch.text.toLowerCase(
                                                                           ))
                                                       })

            onClicked: function (packageName) {
                control.close()
                RaskLauncher.launchApplication(packageName)
                AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
            }
        }
    }

    onVisibleChanged: if (visible)
                          inputSearch.forceActiveFocus()
}
