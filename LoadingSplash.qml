import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Window
Rectangle {
    id: root


    property bool newsReady: false
    property bool manifestReady: false
    property bool assetsReady: false
    property bool minTimeElapsed: false


    property var preloadUrls: []



    property int coversLoaded: 0
    onPreloadUrlsChanged: coversLoaded = 0




    readonly property bool coversReady: coversLoaded >= preloadUrls.length





    property bool coversDone: false
    function _checkCoversDone() { if (!coversDone && manifestReady && coversReady) coversDone = true }
    onCoversReadyChanged: _checkCoversDone()
    onManifestReadyChanged: _checkCoversDone()



    readonly property bool isReady: newsReady && manifestReady && assetsReady
                                    && coversDone && minTimeElapsed

    color: "#060912"
    z: 200
    visible: opacity > 0.01
    opacity: isReady ? 0 : 1
    Behavior on opacity {
        NumberAnimation { duration: 350; easing.type: Easing.InOutQuad }
    }


    MouseArea { anchors.fill: parent; hoverEnabled: true }



    MouseArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 56
        onPressed: if (Window.window) Window.window.startSystemMove()
    }


    Timer {
        interval: 600
        running: true
        repeat: false
        onTriggered: root.minTimeElapsed = true
    }





    Timer {
        interval: 30000
        running: true
        repeat: false
        onTriggered: {
            if (!root.newsReady)     root.newsReady     = true
            if (!root.manifestReady) root.manifestReady = true
            if (!root.assetsReady)   root.assetsReady   = true

            if (!root.coversReady)   root.coversLoaded  = root.preloadUrls.length
            root.coversDone = true
        }
    }






    Repeater {
        model: root.preloadUrls
        delegate: Image {
            required property string modelData
            property int attempt: 0
            readonly property string fallbackSource: (PhotoStore && modelData.length > 0)
                                                    ? PhotoStore.fallbackUrlFor(modelData) : ""
            source: {
                var base = (attempt >= 2 && fallbackSource.length > 0)
                           ? fallbackSource : modelData
                if (attempt === 0) return base
                return base + (base.indexOf("?") >= 0 ? "&" : "?") + "r=" + attempt
            }
            visible: false
            asynchronous: true
            cache: true
            sourceSize.width: 640



            property bool counted: false
            function markDone() {
                if (!counted && (status === Image.Ready || status === Image.Error)) {
                    if (status === Image.Error && attempt < 2 && fallbackSource.length > 0)
                        return
                    counted = true
                    root.coversLoaded += 1
                }
            }
            onStatusChanged: markDone()
            Component.onCompleted: markDone()

            Timer {
                interval: attempt < 4 ? 2500 : 15000
                running: modelData.length > 0 && parent.status === Image.Error && !parent.counted
                repeat: true
                onTriggered: attempt++
            }
        }
    }


    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Image {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 72
            Layout.preferredHeight: 72
            source: "qrc:/icons/data/icon_rounded.png"
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "EXCLUSION LAUNCHER"
            color: "#F4F6FA"
            font.pixelSize: 14
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: {
                var lang = AppI18n.language
                if (root.isReady) return AppI18n.t("splash.ready")
                var parts = []
                if (!root.newsReady)     parts.push(AppI18n.t("splash.news"))
                if (!root.manifestReady) parts.push(AppI18n.t("splash.clients"))
                if (!root.assetsReady)   parts.push(AppI18n.t("splash.assets"))

                if (root.manifestReady && !root.coversDone && root.preloadUrls.length > 0)
                    parts.push(AppI18n.t("splash.assets") + " "
                               + root.coversLoaded + "/" + root.preloadUrls.length)
                return AppI18n.t("splash.loading") + " " + parts.join(" · ")
            }
            color: "#8590A2"
            font.pixelSize: 11
        }


        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 220
            Layout.preferredHeight: 4
            radius: 2
            color: "#1A2434"
            clip: true

            Rectangle {
                width: 60
                height: parent.height
                radius: 2
                color: AppSettings ? AppSettings.accentColor : "#8A63F5"

                SequentialAnimation on x {
                    loops: Animation.Infinite
                    running: root.visible
                    NumberAnimation { from: -60; to: 220; duration: 1200; easing.type: Easing.InOutSine }
                }
            }
        }
    }
}



