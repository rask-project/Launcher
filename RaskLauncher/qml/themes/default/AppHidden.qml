import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtRask.Launcher 1.0

import "components"

Dialog {
    id: control

    property int posY: Screen.height

    width: parent.width
    onHeightChanged: console.log("Dialog", height)

    padding: 0
    margins: 0
    horizontalPadding: 0
    modal: true

    property int widthAvailable: width - leftMargin - rightMargin
    property var model: []
    property int iconSize: 45
    property int iconSpacing: 25

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentHeight: applicationFlow.implicitHeight

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
                    icon: "image://systemImage/" + packageName
                    adaptativeIcon: modelData.adaptativeIcon

                    click.onClicked: {
                        control.visible = false
                        RaskLauncher.launchApplication(packageName)
                        AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
                    }

                    click.onPressAndHold: {
                        actions.visible = true
                        AndroidVibrate.vibrate(
                                    200, AndroidVibrate.EFFECT_HEAVY_CLICK)
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
                                    RaskLauncher.uninstallApplication(
                                                packageName)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    background: Item {}

    Overlay.modal: BlurOverlay {}

    enter: Transition {
        NumberAnimation {
            property: "y"
            from: Screen.height / 2
            to: 0
            easing.type: Easing.OutQuint
            duration: 500
        }
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.OutCubic
            duration: 800
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "y"
            from: 0
            to: Screen.height / 2
            easing.type: Easing.OutQuint
            duration: 200
        }

        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.OutCubic
            duration: 500
        }
    }
}
