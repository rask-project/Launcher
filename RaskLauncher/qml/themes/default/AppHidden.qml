import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import QtRask.Launcher 1.0

import "components"

OverlaySheet {
    id: control

    property int widthAvailable: width - leftMargin - rightMargin
    property var model
    property int iconSize: 45
    property int iconSpacing: 25

    padding: 30
    leftPadding: 10
    rightPadding: 10

    AppGrid {
        width: parent.width
        height: parent.height

        model: control.model

        onClicked: function (packageName) {
            control.close()
            RaskLauncher.launchApplication(packageName)
            AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
        }

        actionOptions: ListModel {
            ListElement {
                label: qsTr("Show App in grid")
                iconName: "visibility"

                property var func: function () {
                    control.visible = false
                    Applications.showApplication(modelData.packageName)
                }
            }

            ListElement {
                label: qsTr("Uninstall")
                iconName: "delete"

                property var func: function () {
                    control.visible = false
                    RaskLauncher.uninstallApplication(packageName)
                }
            }
        }
    }
}
