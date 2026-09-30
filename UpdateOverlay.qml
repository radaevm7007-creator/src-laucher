import QtQuick
import QtQuick.Layouts
import QtQuick.Window
Rectangle {
    id: root

    readonly property bool downloading: DownloadManager.busy
    readonly property bool launching: GameLauncher.preparing
    readonly property bool active: downloading || launching

    readonly property real barProgress: downloading ? DownloadManager.progress
                                                    : GameLauncher.progress
    readonly property string headline: downloading
        ? (DownloadManager.statusText.length > 0 ? DownloadManager.statusText
                                                 : root.tr("update.downloading"))
        : (GameLauncher.stageText.length > 0 ? GameLauncher.stageText
                                             : root.tr("update.starting"))

    function tr(key) { return (AppI18n.language, AppI18n.t(key)) }


    function _clientName() {
        var id = downloading ? DownloadManager.currentClientId : GameLauncher.preparingClientId
        var list = ManifestManager.clients
        for (var i = 0; i < list.length; ++i)
            if (list[i].id === id) return list[i].name || list[i].id
        return id
    }



    function _clientCover() {
        var id = downloading ? DownloadManager.currentClientId : GameLauncher.preparingClientId
        var list = ManifestManager.clients
        for (var i = 0; i < list.length; ++i)
            if (list[i].id === id) return list[i].coverUrl || ""
        return ""
    }

    color: "#060912"
    z: 200
    visible: opacity > 0.01
    opacity: active ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }


    MouseArea { anchors.fill: parent; hoverEnabled: true }



    RainParticles {
        anchors.fill: parent
        count: 130
    }




    MouseArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 56
        onPressed: if (Window.window) Window.window.startSystemMove()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 18



        RoundedImage {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 104
            Layout.preferredHeight: 104
            radius: 22
            source: root._clientCover()

            Image {
                anchors.fill: parent
                source: "qrc:/icons/data/icon_rounded.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.downloading ? root.tr("update.title") : root.tr("update.launchTitle")
            color: "#F4F6FA"
            font.pixelSize: 14
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root._clientName()
            color: "#F1F4FA"
            font.pixelSize: 20
            font.bold: true
            visible: text.length > 0
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: 520
            horizontalAlignment: Text.AlignHCenter
            text: root.headline
            color: "#8590A2"
            font.pixelSize: 12
            elide: Text.ElideRight
        }


        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 320
            Layout.preferredHeight: 4
            radius: 2
            color: "#1A2434"
            clip: true

            Rectangle {
                width: parent.width * Math.max(0, Math.min(1, root.barProgress))
                height: parent.height
                radius: 2
                color: AppSettings.accentColor
                Behavior on width { NumberAnimation { duration: 180 } }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14
            Text {
                text: Math.round(root.barProgress * 100) + "%"
                color: "#8590A2"
                font.pixelSize: 11
                font.bold: true
            }
            Text {
                text: root.downloading ? DownloadManager.speedText : ""
                color: "#8590A2"
                font.pixelSize: 11
                visible: text.length > 0
            }
        }




        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 140
            Layout.preferredHeight: 36
            radius: 10
            visible: root.downloading || root.launching
            color: cancelMouse.containsMouse ? "#1B2434" : "#111927"
            border.width: 1
            border.color: "#26364A"
            Text {
                anchors.centerIn: parent
                text: root.tr("update.cancel")
                color: "#EAEFF7"
                font.pixelSize: 12
            }
            MouseArea {
                id: cancelMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.downloading) DownloadManager.cancel()
                    else GameLauncher.cancelPreparing()
                }
            }
        }
    }
}



