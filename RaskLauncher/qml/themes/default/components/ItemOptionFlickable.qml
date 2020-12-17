import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

Control {
    id: control

    width: parent.width

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    property string text
    property alias icon: iconLabel.icon

    signal triggered

    //topInset: 6
    //bottomInset: 6
    padding: 12
    horizontalPadding: padding - 4
    spacing: 6

    Material.elevation: 5
    Material.background: "transparent"

    font.capitalization: Font.AllUppercase

    contentItem: IconLabel {
        id: iconLabel

        spacing: control.spacing
        mirrored: control.mirrored

        text: control.text
        font: control.font
        color: control.Material.foreground

        icon.width: 24
        icon.height: 24
        icon.color: control.Material.foreground
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: control.Material.buttonHeight
        radius: 2

        color: RaskTheme.getColor(
                   RaskTheme.theme === RaskTheme.Light ? RaskTheme.LightGrey : RaskTheme.DarkGrey,
                   RaskTheme.Alpha20)

        Ripple {
            clipRadius: 2
            width: parent.width
            height: parent.height
            anchor: control
            active: control.focus
            pressed: control.focus
            color: RaskTheme.iconPressed
        }
    }

    Timer {
        id: flickAndHoldStart

        running: control.focus
        interval: 500
        repeat: false

        onTriggered: control.triggered()
    }
}
