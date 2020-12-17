import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "./components"

OverlaySheet {
    id: control

    edge: Qt.BottomEdge

    ColumnLayout {
        width: parent.width
        height: parent.height

        anchors.fill: parent
        anchors.margins: 10

        Label {
            Layout.fillWidth: true
            padding: 10

            text: qsTr("Settings")
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            font.capitalization: Font.AllUppercase
            font.bold: true
            wrapMode: Label.WordWrap
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: column.height

            Column {
                id: column

                width: parent.width
                spacing: 15

                ItemLabel {
                    label: qsTr("Theme")
                    item: ComboBox {
                        width: parent.width
                        model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                        currentIndex: raskSettings.theme
                        onCurrentIndexChanged: if (currentIndex !== raskSettings.theme)
                                                   raskSettings.theme = currentIndex
                    }
                }

                ItemLabel {
                    label: qsTr("Border radius")
                    item: Slider {
                        id: sliderBorderRadius

                        width: parent.width
                        value: raskSettings.iconRadius
                        onValueChanged: if (value !== raskSettings.iconRadius)
                                            raskSettings.iconRadius = value

                        from: 5
                        to: 30
                        stepSize: 5
                        snapMode: Slider.SnapOnRelease

                        ToolTip {
                            parent: sliderBorderRadius.handle
                            visible: sliderBorderRadius.pressed

                            contentItem: AppItem {
                                showAppName: false
                            }
                        }
                    }
                }
            }
        }
    }
}
