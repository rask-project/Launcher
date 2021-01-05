import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0
import "./components"

Page {
    id: page

    topPadding: ScreenManager.statusBarHeight
    bottomPadding: ScreenManager.navigationBarHeight

    property alias applications: appGrid.model
    property alias applicationsHidden: appHidden.model

    background: Item {}
    AppGrid {
        id: appGrid

        width: parent.width
        height: parent.height

        leftMargin: raskSettings.leftPadding
        rightMargin: raskSettings.rightPadding

        //model: page.applications
        onClicked: function (packageName) {
            RaskLauncher.launchApplication(packageName)
            AndroidVibrate.vibrate(50, AndroidVibrate.EFFECT_TICK)
        }

        children: [
            FlickableOptions {
                id: flickableOptions

                flickableItem: appGrid
                contentTop: [
                    ItemOptionFlickable {
                        anchors.horizontalCenter: parent.horizontalCenter

                        icon.name: "search"
                        text: qsTr("Search Apps")

                        onTriggered: {
                            appSearch.open()
                            AndroidVibrate.vibrate(50,
                                                   AndroidVibrate.EFFECT_TICK)
                        }
                    }
                ]

                contentBottom: [
                    ItemOptionFlickable {
                        anchors.horizontalCenter: parent.horizontalCenter

                        icon.name: "visibility"
                        text: qsTr("Hidden Apps")

                        onTriggered: {
                            appHidden.open()
                            AndroidVibrate.vibrate(50,
                                                   AndroidVibrate.EFFECT_TICK)
                        }
                    },
                    ItemOptionFlickable {
                        anchors.horizontalCenter: parent.horizontalCenter
                        icon.name: "settings"
                        text: qsTr("Settings")

                        onTriggered: {
                            appSettings.open()
                            AndroidVibrate.vibrate(50,
                                                   AndroidVibrate.EFFECT_TICK)
                        }
                    }
                ]
            }
        ]

        actions: AppActions {
            id: actions

            name: modelData ? modelData.name : ""

            options: ListModel {
                ListElement {
                    property var labelFunc: function () {
                        return !!actions.modelData
                                && actions.modelData.orderDock ? qsTr("Remove from Dock") : qsTr(
                                                                     "Add to Dock")
                    }

                    iconName: "bookmark"

                    property var func: function () {
                        if (actions.modelData.orderDock)
                            Applications.removeFromDock(
                                        actions.modelData.packageName)
                        else
                            Applications.addToDock(
                                        actions.modelData.packageName)
                    }
                }

                ListElement {
                    label: qsTr("Hide App")
                    iconName: "visibility-off"

                    property var func: function () {
                        Applications.changeVisibility(
                                    actions.modelData.packageName)
                    }
                }

                ListElement {
                    label: qsTr("Information")
                    iconName: "info"

                    property var func: function () {
                        RaskLauncher.openApplicationDetailsSettings(
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

    AppSearch {
        id: appSearch
    }

    AppHidden {
        id: appHidden

        //model: page.applications
    }

    AppSettings {
        id: appSettings
    }

    AppDock {
        visible: model.length > 0

        differencePadding: (ScreenManager.navigationBarVisible ? ScreenManager.navigationBarHeight : raskSettings.padding)
        y: Window.height - (appGrid.atYEnd
                            && !appGrid.atYBeginning ? 0 : height + differencePadding)

        parent: page.parent
        width: parent.width
        shadderSource: appGrid

        model: Applications.dock

        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InOutBounce
                duration: 200
            }
        }
    }

    //background: Rectangle {
    //    Image {
    //        anchors.fill: parent
    //        source: "file:///home/marssola/Pictures/P00613-120151.jpg"
    //        fillMode: Image.PreserveAspectCrop
    //    }
    //}
    property var applications: [{
            "adaptativeIcon": false,
            "name": "0ad",
            "packageName": "0ad"
        }, {
            "adaptativeIcon": false,
            "name": "Adobe Acrobat Reader",
            "packageName": "acroread"
        }, {
            "adaptativeIcon": false,
            "name": "Adobe After Effects",
            "packageName": "AdobeAfterEffect"
        }, {
            "adaptativeIcon": false,
            "name": "Adobe Photoshop",
            "packageName": "AdobePhotoshop"
        }, {
            "adaptativeIcon": false,
            "name": "Anatine",
            "packageName": "anatine"
        }, {
            "adaptativeIcon": false,
            "name": "Android Studio",
            "packageName": "android-studio"
        }, {
            "adaptativeIcon": true,
            "name": "Anjuta",
            "packageName": "anjuta"
        }, {
            "adaptativeIcon": false,
            "name": "Calligra",
            "packageName": "calligrastage"
        }, {
            "adaptativeIcon": false,
            "name": "Chromium",
            "packageName": "chromium-browser"
        }, {
            "adaptativeIcon": true,
            "name": "CPU AMD",
            "packageName": "cpu-amd"
        }, {
            "adaptativeIcon": true,
            "name": "CPU Info",
            "packageName": "cpuinfo"
        }, {
            "adaptativeIcon": false,
            "name": "Display",
            "packageName": "display"
        }, {
            "adaptativeIcon": false,
            "name": "Finder",
            "packageName": "file-manager"
        }, {
            "adaptativeIcon": false,
            "name": "Firefox",
            "packageName": "firefox"
        }, {
            "adaptativeIcon": false,
            "name": "Geany",
            "packageName": "geany"
        }, {
            "adaptativeIcon": false,
            "name": "Gnome Books",
            "packageName": "gnome-books"
        }, {
            "adaptativeIcon": false,
            "name": "Kodi",
            "packageName": "kodi"
        }, {
            "adaptativeIcon": false,
            "name": "Libre Office Calc",
            "packageName": "libreoffice-calc"
        }, {
            "adaptativeIcon": false,
            "name": "Libre Office Draw",
            "packageName": "libreoffice-draw"
        }, {
            "adaptativeIcon": false,
            "name": "Libre Office Writer",
            "packageName": "libreoffice-writer"
        }, {
            "adaptativeIcon": false,
            "name": "Luminance HDR",
            "packageName": "luminance-hdr"
        }, {
            "adaptativeIcon": false,
            "name": "Message",
            "packageName": "message"
        }, {
            "adaptativeIcon": false,
            "name": "Microsoft Office",
            "packageName": "ms-office"
        }, {
            "adaptativeIcon": false,
            "name": "Microsoft Office Excel",
            "packageName": "ms-excel"
        }, {
            "adaptativeIcon": false,
            "name": "Microsoft Office One Note",
            "packageName": "ms-onenote"
        }, {
            "adaptativeIcon": false,
            "name": "Microsoft Office Outlook",
            "packageName": "ms-outlook"
        }, {
            "adaptativeIcon": false,
            "name": "Microsoft Office PowerPoint",
            "packageName": "ms-powerpoint"
        }, {
            "adaptativeIcon": false,
            "name": "Microsoft Office Word",
            "packageName": "ms-word"
        }, {
            "adaptativeIcon": false,
            "name": "Minitube",
            "packageName": "minitube"
        }, {
            "adaptativeIcon": false,
            "name": "mongodb Compass",
            "packageName": "mongodb-compass"
        }, {
            "adaptativeIcon": false,
            "name": "Okular",
            "packageName": "okular"
        }, {
            "adaptativeIcon": true,
            "name": "Opera",
            "packageName": "opera"
        }, {
            "adaptativeIcon": false,
            "name": "PCSXR",
            "packageName": "pcsxr"
        }, {
            "adaptativeIcon": true,
            "name": "pgadmin3",
            "packageName": "pgadmin3"
        }, {
            "adaptativeIcon": false,
            "name": "Pitivi",
            "packageName": "pitivi"
        }, {
            "adaptativeIcon": true,
            "name": "Plasma",
            "packageName": "plasma"
        }, {
            "adaptativeIcon": false,
            "name": "Postman",
            "packageName": "postman"
        }, {
            "adaptativeIcon": false,
            "name": "Preferences System Privacy",
            "packageName": "preferences-system-privacy"
        }, {
            "adaptativeIcon": false,
            "name": "Preferences Tweaks",
            "packageName": "preferences-tweaks-anim"
        }, {
            "adaptativeIcon": false,
            "name": "qTransmission",
            "packageName": "qtransmission"
        }]
}
