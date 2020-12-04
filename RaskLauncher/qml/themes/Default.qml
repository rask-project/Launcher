import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

import "../components"

Page {
    id: page

    padding: 20

    //bottomPadding: ScreenManager.navigationBarHeight
    topPadding: ScreenManager.statusBarHeight
    background: Item {}


    /*background: Image {
        source: "file:///home/marssola/Pictures/P00613-120151.jpg"
        fillMode: Image.PreserveAspectCrop
    }*/
    Flickable {
        anchors.fill: parent
        contentHeight: flow.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded

        Flow {
            id: flow

            width: parent.width

            property int itemWidth: 55
            property int columnsAvailable: ((flow.width / flow.itemWidth) | 0) - 1
            spacing: (flow.width - (flow.itemWidth * flow.columnsAvailable)) / flow.columnsAvailable
            leftPadding: spacing / 2

            Repeater {
                //model: page.applications
                model: RaskLauncher.applications

                AppItem {
                    id: itemIcon

                    width: flow.itemWidth
                    parent: flow

                    appName: modelData.name
                    packageName: modelData.packageName
                    adaptative: modelData.adaptativeIcon

                    click.onClicked: {
                        RaskLauncher.launchApplication(itemIcon.packageName)
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
                        parent: page

                        options: ListModel {
                            ListElement {
                                label: qsTr("Information")
                                iconName: "info"

                                property var func: function () {
                                    RaskLauncher.openApplicationDetailsSettings(
                                                itemIcon.packageName)
                                }
                            }

                            ListElement {
                                label: qsTr("Uninstall")
                                iconName: "delete"

                                property var func: function () {
                                    RaskLauncher.uninstallApplication(
                                                itemIcon.packageName)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    property var applications: [{
            "name": "Adobe Acrobat",
            "adaptativeIcon": false,
            "packageName": "com.adobe.reader"
        }, {
            "name": "Agenda",
            "adaptativeIcon": false,
            "packageName": "com.google.android.calendar"
        }, {
            "name": "AliExpress",
            "adaptativeIcon": false,
            "packageName": "com.alibaba.aliexpresshd"
        }, {
            "name": "Anotações",
            "adaptativeIcon": false,
            "packageName": "com.miui.notes"
        }, {
            "name": "Assistente",
            "adaptativeIcon": true,
            "packageName": "com.google.android.apps.googleassistant"
        }, {
            "name": "Bradesco",
            "adaptativeIcon": true,
            "packageName": "com.bradesco"
        }, {
            "name": "Bússola",
            "adaptativeIcon": true,
            "packageName": "com.miui.compass"
        }, {
            "name": "CAIXA Tem",
            "adaptativeIcon": true,
            "packageName": "br.gov.caixa.tem"
        }, {
            "name": "Calculadora Mi",
            "adaptativeIcon": true,
            "packageName": "com.miui.calculator"
        }, {
            "name": "Carteira de Trabalho Digital",
            "adaptativeIcon": true,
            "packageName": "br.gov.dataprev.carteiradigital"
        }, {
            "name": "Carteira Digital de Trânsito",
            "adaptativeIcon": true,
            "packageName": "br.gov.serpro.cnhe"
        }, {
            "name": "Chrome",
            "adaptativeIcon": false,
            "packageName": "com.android.chrome"
        }, {
            "name": "Clima",
            "adaptativeIcon": false,
            "packageName": "com.miui.weather2"
        }, {
            "name": "Configurações",
            "adaptativeIcon": true,
            "packageName": "com.android.settings"
        }, {
            "name": "Contatos",
            "adaptativeIcon": false,
            "packageName": "com.google.android.contacts"
        }, {
            "name": "Câmera",
            "adaptativeIcon": true,
            "packageName": "com.android.camera"
        }, {
            "name": "Câmera",
            "adaptativeIcon": false,
            "packageName": "org.codeaurora.snapcam"
        }, {
            "name": "Digitalizador",
            "adaptativeIcon": true,
            "packageName": "com.xiaomi.scanner"
        }, {
            "name": "Adobe Acrobat",
            "adaptativeIcon": true,
            "packageName": "com.adobe.reader"
        }, {
            "name": "Agenda",
            "adaptativeIcon": true,
            "packageName": "com.google.android.calendar"
        }, {
            "name": "AliExpress",
            "adaptativeIcon": false,
            "packageName": "com.alibaba.aliexpresshd"
        }, {
            "name": "Anotações",
            "adaptativeIcon": true,
            "packageName": "com.miui.notes"
        }, {
            "name": "Assistente",
            "adaptativeIcon": true,
            "packageName": "com.google.android.apps.googleassistant"
        }, {
            "name": "Bradesco",
            "adaptativeIcon": true,
            "packageName": "com.bradesco"
        }, {
            "name": "Bússola",
            "adaptativeIcon": true,
            "packageName": "com.miui.compass"
        }, {
            "name": "CAIXA Tem",
            "adaptativeIcon": true,
            "packageName": "br.gov.caixa.tem"
        }, {
            "name": "Calculadora Mi",
            "adaptativeIcon": true,
            "packageName": "com.miui.calculator"
        }, {
            "name": "Carteira de Trabalho Digital",
            "adaptativeIcon": true,
            "packageName": "br.gov.dataprev.carteiradigital"
        }, {
            "name": "Carteira Digital de Trânsito",
            "adaptativeIcon": true,
            "packageName": "br.gov.serpro.cnhe"
        }, {
            "name": "Chrome",
            "adaptativeIcon": true,
            "packageName": "com.android.chrome"
        }, {
            "name": "Clima",
            "adaptativeIcon": true,
            "packageName": "com.miui.weather2"
        }, {
            "name": "Configurações",
            "adaptativeIcon": true,
            "packageName": "com.android.settings"
        }, {
            "name": "Contatos",
            "adaptativeIcon": true,
            "packageName": "com.google.android.contacts"
        }, {
            "name": "Câmera",
            "adaptativeIcon": true,
            "packageName": "com.android.camera"
        }, {
            "name": "Câmera",
            "adaptativeIcon": true,
            "packageName": "org.codeaurora.snapcam"
        }, {
            "name": "Digitalizador",
            "adaptativeIcon": true,
            "packageName": "com.xiaomi.scanner"
        }, {
            "name": "Adobe Acrobat",
            "adaptativeIcon": false,
            "packageName": "com.adobe.reader"
        }, {
            "name": "Agenda",
            "adaptativeIcon": false,
            "packageName": "com.google.android.calendar"
        }, {
            "name": "AliExpress",
            "adaptativeIcon": false,
            "packageName": "com.alibaba.aliexpresshd"
        }, {
            "name": "Anotações",
            "adaptativeIcon": false,
            "packageName": "com.miui.notes"
        }, {
            "name": "Assistente",
            "adaptativeIcon": true,
            "packageName": "com.google.android.apps.googleassistant"
        }, {
            "name": "Bradesco",
            "adaptativeIcon": true,
            "packageName": "com.bradesco"
        }, {
            "name": "Bússola",
            "adaptativeIcon": true,
            "packageName": "com.miui.compass"
        }, {
            "name": "CAIXA Tem",
            "adaptativeIcon": true,
            "packageName": "br.gov.caixa.tem"
        }, {
            "name": "Calculadora Mi",
            "adaptativeIcon": true,
            "packageName": "com.miui.calculator"
        }, {
            "name": "Carteira de Trabalho Digital",
            "adaptativeIcon": true,
            "packageName": "br.gov.dataprev.carteiradigital"
        }, {
            "name": "Carteira Digital de Trânsito",
            "adaptativeIcon": true,
            "packageName": "br.gov.serpro.cnhe"
        }, {
            "name": "Chrome",
            "adaptativeIcon": false,
            "packageName": "com.android.chrome"
        }, {
            "name": "Clima",
            "adaptativeIcon": false,
            "packageName": "com.miui.weather2"
        }, {
            "name": "Configurações",
            "adaptativeIcon": true,
            "packageName": "com.android.settings"
        }, {
            "name": "Contatos",
            "adaptativeIcon": false,
            "packageName": "com.google.android.contacts"
        }, {
            "name": "Câmera",
            "adaptativeIcon": true,
            "packageName": "com.android.camera"
        }, {
            "name": "Câmera",
            "adaptativeIcon": false,
            "packageName": "org.codeaurora.snapcam"
        }, {
            "name": "Digitalizador",
            "adaptativeIcon": true,
            "packageName": "com.xiaomi.scanner"
        }, {
            "name": "Adobe Acrobat",
            "adaptativeIcon": true,
            "packageName": "com.adobe.reader"
        }, {
            "name": "Agenda",
            "adaptativeIcon": true,
            "packageName": "com.google.android.calendar"
        }, {
            "name": "AliExpress",
            "adaptativeIcon": false,
            "packageName": "com.alibaba.aliexpresshd"
        }, {
            "name": "Anotações",
            "adaptativeIcon": true,
            "packageName": "com.miui.notes"
        }, {
            "name": "Assistente",
            "adaptativeIcon": true,
            "packageName": "com.google.android.apps.googleassistant"
        }, {
            "name": "Bradesco",
            "adaptativeIcon": true,
            "packageName": "com.bradesco"
        }, {
            "name": "Bússola",
            "adaptativeIcon": true,
            "packageName": "com.miui.compass"
        }, {
            "name": "CAIXA Tem",
            "adaptativeIcon": true,
            "packageName": "br.gov.caixa.tem"
        }, {
            "name": "Calculadora Mi",
            "adaptativeIcon": true,
            "packageName": "com.miui.calculator"
        }, {
            "name": "Carteira de Trabalho Digital",
            "adaptativeIcon": true,
            "packageName": "br.gov.dataprev.carteiradigital"
        }, {
            "name": "Carteira Digital de Trânsito",
            "adaptativeIcon": true,
            "packageName": "br.gov.serpro.cnhe"
        }, {
            "name": "Chrome",
            "adaptativeIcon": true,
            "packageName": "com.android.chrome"
        }, {
            "name": "Clima",
            "adaptativeIcon": true,
            "packageName": "com.miui.weather2"
        }, {
            "name": "Configurações",
            "adaptativeIcon": true,
            "packageName": "com.android.settings"
        }, {
            "name": "Contatos",
            "adaptativeIcon": true,
            "packageName": "com.google.android.contacts"
        }, {
            "name": "Câmera",
            "adaptativeIcon": true,
            "packageName": "com.android.camera"
        }, {
            "name": "Câmera",
            "adaptativeIcon": true,
            "packageName": "org.codeaurora.snapcam"
        }, {
            "name": "Digitalizador",
            "adaptativeIcon": true,
            "packageName": "com.xiaomi.scanner"
        }]
}
