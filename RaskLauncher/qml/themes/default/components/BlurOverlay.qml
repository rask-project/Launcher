import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtRask.Launcher 1.0

Rectangle {
    id: overlay

    color: RaskTheme.background

    FastBlur {
        id: fastBlur

        anchors.fill: parent
        radius: 100
        opacity: 0.7

        source: ShaderEffectSource {
            id: shader
            anchors.fill: parent
            sourceItem: ApplicationWindow.contentItem
            sourceRect: Qt.rect(overlay.x, overlay.y, overlay.width,
                                overlay.height)
        }
    }
}
