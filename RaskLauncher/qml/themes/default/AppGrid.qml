import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

Flickable {
    id: scrollGrid

    contentHeight: applicationFlow.implicitHeight

    property int widthAvailable: width - leftMargin - rightMargin
    property var model: []
    property int iconSize: 45
    property int iconSpacing: 25

    Flow {
        id: applicationFlow

        width: parent.width
        leftPadding: (scrollGrid.widthAvailable
                      % (scrollGrid.iconSize + scrollGrid.iconSpacing)) / 2
        rightPadding: leftPadding

        Repeater {
            model: scrollGrid.model

            AppItem {
                width: scrollGrid.iconSize + scrollGrid.iconSpacing

                applicationName: modelData.name
                packageName: modelData.packageName
                icon: modelData.icon
                //icon: "image://systemImage/" + modelData.packageName
                iconAdaptative: modelData.iconAdaptative

                click.onClicked: {
                    RaskLauncher.launchApplication(modelData.packageName)
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
                    parent: scrollGrid

                    options: ListModel {
                        ListElement {
                            label: qsTr("Add to Dock")
                            iconName: "bookmark"

                            property var func: function () {}
                        }

                        ListElement {
                            label: qsTr("Hide App")
                            iconName: "visibility-off"

                            property var func: function () {}
                        }

                        ListElement {
                            label: qsTr("Information")
                            iconName: "info"

                            property var func: function () {
                                RaskLauncher.openApplicationDetailsSettings(
                                            modelData.packageName)
                            }
                        }

                        ListElement {
                            label: qsTr("Uninstall")
                            iconName: "delete"

                            property var func: function () {
                                RaskLauncher.uninstallApplication(
                                            modelData.packageName)
                            }
                        }
                    }
                }
            }
        }
    }
}
