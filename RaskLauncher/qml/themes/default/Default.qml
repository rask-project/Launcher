import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Page {
    id: page

    padding: 30
    leftPadding: 10
    rightPadding: 10

    background: Item {}

    //background: Rectangle {
    //    Image {
    //        anchors.fill: parent
    //        source: "file:///home/marssola/Pictures/P00613-120151.jpg"
    //        fillMode: Image.PreserveAspectCrop
    //    }
    //}
    AppGrid {
        id: appGrid

        width: parent.width
        height: parent.height

        model: page.applications
    }

    footer: AppDock {
        visible: model.length > 0
        width: parent.width
        height: 100

        anchors.bottom: parent.bottom
        shadderSource: appGrid
        model: page.applications.splice(10, 10)
    }

    property var applications: [{
            "name": "0ad",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/0ad.svg"
        }, {
            "name": "Microsoft Excel",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/7A63_EXCEL.0.svg"
        }, {
            "name": "7z",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/7z.svg"
        }, {
            "name": "Microsoft Word",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/399B_WINWORD.0.svg"
        }, {
            "name": "Microsoft PowerPoint",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/879C_POWERPNT.0.svg"
        }, {
            "name": "Outlook",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/9582_OUTLOOK.0.svg"
        }, {
            "name": "Adobe After Effects",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/AdobeAfterEffect.svg"
        }, {
            "name": "Adobe Photoshop",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/AdobePhotoshop.svg"
        }, {
            "name": "Anki",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/anki.svg"
        }, {
            "name": "Applications System",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/applications-system.svg"
        }, {
            "name": "Calculator",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/chrome-calculator.svg"
        }, {
            "name": "Microsoft One Note",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/chrome-ciniambnphakdoflgeamacamhfllbkmo-Default.svg"
        }, {
            "name": "CPU Info",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/cpuinfo.svg"
        }, {
            "name": "Device Notifier",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/device-notifier.svg"
        }, {
            "name": "Konsole",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/konsole.svg"
        }, {
            "name": "KSystemLog",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/ksystemlog.svg"
        }, {
            "name": "KWik Disk",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/kwikdisk.svg"
        }, {
            "name": "Kynaptic",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/kynaptic.svg"
        }, {
            "name": "Libreoffice Calc",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/libreoffice-calc.svg"
        }, {
            "name": "Libreoffice Writer",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/libreoffice-writer.svg"
        }, {
            "name": "Finder",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/mc.svg"
        }, {
            "name": "Nylas Mail",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/nylas.svg"
        }, {
            "name": "Rhythmbox",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/org.gnome.Rhythmbox3.svg"
        }, {
            "name": "QuickTime",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/org.kde.plasma.mediacontroller.svg"
        }, {
            "name": "0ad",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/0ad.svg"
        }, {
            "name": "Microsoft Excel",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/7A63_EXCEL.0.svg"
        }, {
            "name": "7z",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/7z.svg"
        }, {
            "name": "Microsoft Word",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/399B_WINWORD.0.svg"
        }, {
            "name": "Microsoft PowerPoint",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/879C_POWERPNT.0.svg"
        }, {
            "name": "Outlook",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/9582_OUTLOOK.0.svg"
        }, {
            "name": "Adobe After Effects",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/AdobeAfterEffect.svg"
        }, {
            "name": "Adobe Photoshop",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/AdobePhotoshop.svg"
        }, {
            "name": "Anki",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/anki.svg"
        }, {
            "name": "Applications System",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/applications-system.svg"
        }, {
            "name": "Calculator",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/chrome-calculator.svg"
        }, {
            "name": "Microsoft One Note",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/chrome-ciniambnphakdoflgeamacamhfllbkmo-Default.svg"
        }, {
            "name": "CPU Info",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/cpuinfo.svg"
        }, {
            "name": "Device Notifier",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/device-notifier.svg"
        }, {
            "name": "Konsole",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/konsole.svg"
        }, {
            "name": "KSystemLog",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/ksystemlog.svg"
        }, {
            "name": "KWik Disk",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/kwikdisk.svg"
        }, {
            "name": "Kynaptic",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/kynaptic.svg"
        }, {
            "name": "Libreoffice Calc",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/libreoffice-calc.svg"
        }, {
            "name": "Libreoffice Writer",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/libreoffice-writer.svg"
        }, {
            "name": "Finder",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/mc.svg"
        }, {
            "name": "Nylas Mail",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/nylas.svg"
        }, {
            "name": "Rhythmbox",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/org.gnome.Rhythmbox3.svg"
        }, {
            "name": "QuickTime",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/org.kde.plasma.mediacontroller.svg"
        }, {
            "name": "0ad",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/0ad.svg"
        }, {
            "name": "Microsoft Excel",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/7A63_EXCEL.0.svg"
        }, {
            "name": "7z",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/7z.svg"
        }, {
            "name": "Microsoft Word",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/399B_WINWORD.0.svg"
        }, {
            "name": "Microsoft PowerPoint",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/879C_POWERPNT.0.svg"
        }, {
            "name": "Outlook",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/9582_OUTLOOK.0.svg"
        }, {
            "name": "Adobe After Effects",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/AdobeAfterEffect.svg"
        }, {
            "name": "Adobe Photoshop",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/AdobePhotoshop.svg"
        }, {
            "name": "Anki",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/anki.svg"
        }, {
            "name": "Applications System",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/applications-system.svg"
        }, {
            "name": "Calculator",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/chrome-calculator.svg"
        }, {
            "name": "Microsoft One Note",
            "packageName": "",
            "iconAdaptative": true,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/chrome-ciniambnphakdoflgeamacamhfllbkmo-Default.svg"
        }, {
            "name": "CPU Info",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/cpuinfo.svg"
        }, {
            "name": "Device Notifier",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/device-notifier.svg"
        }, {
            "name": "Konsole",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/konsole.svg"
        }, {
            "name": "KSystemLog",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/ksystemlog.svg"
        }, {
            "name": "KWik Disk",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/kwikdisk.svg"
        }, {
            "name": "Kynaptic",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/kynaptic.svg"
        }, {
            "name": "Libreoffice Calc",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/libreoffice-calc.svg"
        }, {
            "name": "Libreoffice Writer",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/libreoffice-writer.svg"
        }, {
            "name": "Finder",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/mc.svg"
        }, {
            "name": "Nylas Mail",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/nylas.svg"
        }, {
            "name": "Rhythmbox",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/org.gnome.Rhythmbox3.svg"
        }, {
            "name": "QuickTime",
            "packageName": "",
            "iconAdaptative": false,
            "icon": "file:///home/marssola/.local/share/icons/Os-Catalina-icons/128x128/apps/org.kde.plasma.mediacontroller.svg"
        }]
}
