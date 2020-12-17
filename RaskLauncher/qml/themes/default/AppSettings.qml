import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import QtRask.Launcher 1.0
import "./components"

OverlaySheet {
    id: control

    edge: Qt.BottomEdge

    readonly property var applicationsExample: Applications.list.slice(0, 5)

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
                spacing: 20

                ItemLabel {
                    label: qsTr("Theme")
                    item: ComboBox {
                        width: parent.width
                        flat: true

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
                        to: raskSettings.iconSize / 2
                        stepSize: 5
                        snapMode: Slider.SnapOnRelease

                        ToolTip {
                            parent: sliderBorderRadius
                            visible: sliderBorderRadius.pressed

                            contentItem: AppItem {
                                width: raskSettings.iconSize + raskSettings.iconSpacing
                                iconSize: raskSettings.iconSize
                                applicationName: control.applicationsExample[1].name
                                packageName: control.applicationsExample[1].packageName
                                icon: "image://systemImage/" + packageName
                            }
                        }
                    }
                }

                ItemLabel {
                    label: qsTr("Icon size")
                    item: Slider {
                        id: sliderIconSize

                        width: parent.width
                        value: raskSettings.iconSize
                        onValueChanged: if (value !== raskSettings.iconSize)
                                            raskSettings.iconSize = value

                        from: 35
                        to: 80
                        stepSize: 5
                        snapMode: Slider.SnapOnRelease

                        ToolTip {
                            parent: sliderIconSize
                            visible: sliderIconSize.pressed

                            contentItem: AppItem {
                                width: raskSettings.iconSize + raskSettings.iconSpacing
                                iconSize: raskSettings.iconSize
                                applicationName: control.applicationsExample[2].name
                                packageName: control.applicationsExample[2].packageName
                                icon: "image://systemImage/" + packageName
                            }
                        }
                    }
                }

                ItemLabel {
                    id: itemLabelIconSpacing

                    label: qsTr("Icon spacing")
                    item: Slider {
                        id: sliderIconSpacing

                        width: parent.width
                        value: raskSettings.iconSpacing
                        onValueChanged: if (value !== raskSettings.iconSpacing)
                                            raskSettings.iconSpacing = value

                        from: 10
                        to: 40
                        stepSize: 5
                        snapMode: Slider.SnapOnRelease

                        ToolTip {
                            width: 250
                            parent: sliderIconSpacing
                            visible: sliderIconSpacing.pressed

                            contentItem: Flow {
                                width: parent.width

                                topPadding: 15
                                leftPadding: (width % (raskSettings.iconSize
                                                       + raskSettings.iconSpacing)) / 2
                                rightPadding: leftPadding

                                Repeater {
                                    model: control.applicationsExample

                                    AppItem {
                                        width: raskSettings.iconSize + raskSettings.iconSpacing
                                        iconSize: raskSettings.iconSize
                                        applicationName: modelData.name
                                        packageName: modelData.packageName
                                        icon: "image://systemImage/" + packageName
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
