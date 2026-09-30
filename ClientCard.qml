import QtQuick
import QtQuick.Controls
Rectangle {
    id: card
    property var clientData
    property int installRevision: InstalledStore.revision
    readonly property bool installed: {
        installRevision
        return (InstalledStore.revision, InstalledStore.isInstalled)(clientData.id)
    }
    readonly property bool updateAvailable: installed
                                            && ((InstalledStore.revision, InstalledStore.installedVersion)(clientData.id) !== String(clientData.version || "")
                                                || (InstalledStore.revision, InstalledStore.needsUpdate)(clientData.id, String(clientData.sha256 || ""), String(clientData.packageUrl || "")))
    readonly property bool isCurrent: DownloadManager.busy && DownloadManager.currentClientId === clientData.id

    width: 338
    height: 330
    radius: 16
    color: cardMouse.containsMouse ? "#121B28" : "#0F1722"
    border.width: 1
    border.color: cardMouse.containsMouse ? "#26364A" : "#1B2635"
    scale: cardMouse.containsMouse ? 1.012 : 1.0

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    Rectangle {
        id: art
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        height: 128
        radius: 12
        clip: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker(card.clientData.accent, 2.5) }
            GradientStop { position: 0.55; color: Qt.darker(card.clientData.accent, 1.7) }
            GradientStop { position: 1.0; color: "#0A111B" }
        }

        Rectangle {
            width: 160; height: 160; radius: 80
            anchors.right: parent.right; anchors.rightMargin: -40
            anchors.verticalCenter: parent.verticalCenter
            color: card.clientData.accent
            opacity: 0.12
        }
        Rectangle {
            width: 95; height: 95; radius: 22
            anchors.right: parent.right; anchors.rightMargin: 28
            anchors.verticalCenter: parent.verticalCenter
            rotation: 18
            color: "transparent"
            border.width: 2
            border.color: card.clientData.accent
            opacity: 0.45
        }
        Text {
            anchors.left: parent.left; anchors.leftMargin: 20
            anchors.bottom: parent.bottom; anchors.bottomMargin: 17
            text: card.clientData.name.toUpperCase().split(" ")[0]
            color: "#F5FAFF"
            font.pixelSize: 23
            font.bold: true
            font.letterSpacing: 1.4
        }
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: art.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 18
        anchors.topMargin: 15
        spacing: 7

        Row {
            width: parent.width
            spacing: 8
            Text {
                text: card.clientData.name
                color: "#F1F6FF"
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }
            Rectangle {
                width: versionText.width + 12; height: 22; radius: 7
                color: "#172231"
                Text { id: versionText; anchors.centerIn: parent; text: card.clientData.minecraft; color: "#778CA5"; font.pixelSize: 10 }
            }
        }

        Text {
            text: card.clientData.description
            color: "#75859B"
            font.pixelSize: 11
            wrapMode: Text.WordWrap
            width: parent.width
            height: 33
        }

        Item { width: 1; height: 3 }

        Row {
            width: parent.width
            spacing: 12
            Text { text: card.clientData.sizeText; color: "#69798E"; font.pixelSize: 11 }
            Text {
                text: card.updateAvailable ? "● Доступно обновление" : (card.installed ? "● Установлен" : "● Не установлен")
                color: card.updateAvailable ? "#F3B657" : (card.installed ? "#65D695" : "#64758A")
                font.pixelSize: 11
            }
        }

        Item { width: 1; height: 4 }

        Rectangle {
            width: parent.width
            height: 5
            radius: 3
            color: "#1A2432"
            visible: card.isCurrent
            Rectangle {
                width: parent.width * Math.max(0.02, DownloadManager.progress)
                height: parent.height
                radius: parent.radius
                color: AppSettings.accentColor
            }
        }

        Row {
            width: parent.width
            spacing: 8
            ExclusionButton {
                width: card.installed ? 190 : parent.width
                text: card.isCurrent ? DownloadManager.statusText : (card.updateAvailable ? "Обновить" : (card.installed ? "Переустановить" : "Скачать"))
                enabled: !DownloadManager.busy || card.isCurrent
                onClicked: {
                    if (card.isCurrent) DownloadManager.cancel()
                    else DownloadManager.installClient(card.clientData)
                }
            }
            ExclusionButton {
                visible: card.installed
                width: 100
                primary: false
                text: "Удалить"
                enabled: !DownloadManager.busy
                onClicked: DownloadManager.removeClient(card.clientData.id)
            }
        }

        Text {
            visible: card.isCurrent
            text: DownloadManager.speedText
            color: "#6F8299"
            font.pixelSize: 10
        }
    }

    MouseArea {
        id: cardMouse
        anchors.fill: art
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }
}



