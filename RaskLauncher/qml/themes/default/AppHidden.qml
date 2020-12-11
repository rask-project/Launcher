import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

//import QtRask.Launcher 1.0
import "components"

OverlaySheet {
    id: control

    property int widthAvailable: width - leftMargin - rightMargin
    property var model: []
    property int iconSize: 45
    property int iconSpacing: 25

    Flow {
        id: applicationFlow

        width: parent.width

        leftPadding: (control.widthAvailable % (control.iconSize + control.iconSpacing)) / 2
        rightPadding: leftPadding

        Repeater {
            id: repeater

            model: control.model

            AppItem {
                width: control.iconSize + control.iconSpacing

                applicationName: modelData.name
                packageName: modelData.packageName
                //icon: "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/" + packageName + ".svg"
                icon: "image://systemImage/" + packageName
                adaptativeIcon: modelData.adaptativeIcon

                click.onClicked: {
                    control.visible = false
                    RaskLauncher.launchApplication(packageName)
                    AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
                }

                click.onPressAndHold: {
                    actions.visible = true
                    AndroidVibrate.vibrate(200,
                                           AndroidVibrate.EFFECT_HEAVY_CLICK)
                }

                AppActions {
                    id: actions

                    name: modelData.name

                    options: ListModel {
                        ListElement {
                            label: qsTr("Show App in grid")
                            iconName: "visibility"

                            property var func: function () {
                                control.visible = false
                                Applications.showApplication(
                                            modelData.packageName)
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
        }
    }
}
