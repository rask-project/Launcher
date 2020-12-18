import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import QtRask.Launcher 1.0
import "components"

OverlaySheet {
    id: control

    property var model: []

    ColumnLayout {
        width: parent.width
        height: parent.height

        Label {
            visible: control.model.length === 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: qsTr("No hidden apps")
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            font.capitalization: Font.AllUppercase
            wrapMode: Label.WordWrap
        }

        Label {
            visible: control.model.length > 0

            Layout.fillWidth: true
            padding: 10

            text: qsTr("Hidden apps")
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            font.capitalization: Font.AllUppercase
            font.bold: true
            wrapMode: Label.WordWrap
        }

        AppGrid {
            visible: control.model.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            textNegative: RaskTheme.theme === RaskTheme.Light
            model: control.model

            onClicked: function (packageName) {
                control.close()
                RaskLauncher.launchApplication(packageName)
                AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
            }

            actions: AppActions {
                id: actions

                name: modelData ? modelData.name : ""
                options: ListModel {
                    ListElement {
                        property var labelFunc: function () {
                            return !!actions.modelData
                                    && Applications.isOnTheDock(
                                        actions.modelData.packageName) ? qsTr("Remove from Dock") : qsTr("Add to Dock")
                        }

                        iconName: "bookmark"

                        property var func: function () {
                            if (Applications.isOnTheDock(
                                        actions.modelData.packageName))
                                Applications.removeFromDock(
                                            actions.modelData.packageName)
                            else
                                Applications.addToDock(
                                            actions.modelData.packageName)
                        }
                    }

                    ListElement {
                        label: qsTr("Show App in grid")
                        iconName: "visibility"

                        property var func: function () {
                            Applications.showApplication(
                                        actions.modelData.packageName)
                        }
                    }

                    ListElement {
                        label: qsTr("Uninstall")
                        iconName: "delete"

                        property var func: function () {
                            RaskLauncher.uninstallApplication(
                                        actions.modelData.packageName)
                        }
                    }
                }
            }
        }
    }
}
