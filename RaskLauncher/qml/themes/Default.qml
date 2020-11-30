import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import QtRask.Launcher 1.0
import "../components"

Page {
    id: page

    //onWidthChanged: console.log("Width", width)
    //onHeightChanged: console.log("Height", height)
    background: Image {
        source: "file:///home/marssola/Pictures/P00613-120151.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        width: parent.width
        height: parent.height

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
        }

        ScrollablePage {
            id: scrollablePage

            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 10

            Grid {
                id: grid

                property int itemWidth: 50
                property int spaceAvailable: (scrollablePage.width / grid.itemWidth) - 2

                columns: (grid.spaceAvailable | 0)
                columnSpacing: ((scrollablePage.width - scrollablePage.padding * 2)
                                - (grid.itemWidth * grid.columns)) / grid.columns

                Repeater {
                    //model: page.applications
                    model: RaskLauncher.applications

                    ItemIcon {
                        width: grid.itemWidth
                        height: 110
                        iconWidth: 50
                        iconHeight: 50

                        appName: modelData.name
                        packageName: modelData.packageName
                        adaptative: modelData.adaptativeIcon
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
        }
    }

    property var applications: [{
            "name": "Adobe Acrobat",
            "adaptativeIcon": true,
            "packageName": "com.adobe.reader"
        }, {
            "name": "Agenda",
            "adaptativeIcon": true,
            "packageName": "com.google.android.calendar"
        }, {
            "name": "AliExpress",
            "adaptativeIcon": true,
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
            "adaptativeIcon": true,
            "packageName": "com.adobe.reader"
        }, {
            "name": "Agenda",
            "adaptativeIcon": true,
            "packageName": "com.google.android.calendar"
        }, {
            "name": "AliExpress",
            "adaptativeIcon": true,
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
