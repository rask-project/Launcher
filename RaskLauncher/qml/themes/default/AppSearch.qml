import QtQuick 2.15
import QtQuick.Layouts 1.15

import QtRask.Launcher 1.0
import "./components"

OverlaySheet {
    id: control

    edge: Qt.TopEdge

    padding: 10
    topPadding: 30

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        Item {
            z: 100

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
            z: 1

            Layout.fillWidth: true
            Layout.fillHeight: true

            property var listSearched: Applications.list.concat(
                                           Applications.hidden).filter(
                                           function (app) {
                                               return app["name"].toLowerCase(
                                                           ).match(
                                                           inputSearch.text.toLowerCase(
                                                               ))
                                           }).sort(function (a, b) {
                                               return a["name"].toLowerCase(
                                                           ) < b["name"].toLowerCase()
                                           })

            model: inputSearch.text.length === 0 ? [] : listSearched

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
