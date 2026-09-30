import QtQuick
import QtQuick.Controls
Item {
    id: root

    property var urls: []
    property int index: 0
    readonly property bool shown: opacity > 0.01

    function open(list, startIndex) {
        if (!list || list.length === 0) return
        urls = list
        index = Math.max(0, Math.min(startIndex || 0, list.length - 1))
        opacity = 1
        forceActiveFocus()
    }
    function close() { opacity = 0 }
    function next()  { if (urls.length > 1) index = (index + 1) % urls.length }
    function prev()  { if (urls.length > 1) index = (index - 1 + urls.length) % urls.length }
    property int _attempt: 0
    onIndexChanged: _attempt = 0
    onUrlsChanged: _attempt = 0
    readonly property string _currentUrl: root.urls.length > 0 ? root.urls[root.index] : ""
    readonly property string _fallbackUrl: (PhotoStore && root._currentUrl.length > 0)
                                          ? PhotoStore.fallbackUrlFor(root._currentUrl) : ""

    anchors.fill: parent
    visible: shown
    opacity: 0
    z: 300
    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }


    Rectangle {
        anchors.fill: parent
        color: "#F2050810"
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.close()
            onWheel: function(wheel) { wheel.angleDelta.y < 0 ? root.next() : root.prev() }
        }
    }


    focus: root.shown
    Keys.onLeftPressed:   root.prev()
    Keys.onRightPressed:  root.next()
    Keys.onEscapePressed: root.close()


    Image {
        id: bigImage
        anchors.centerIn: parent
        width: Math.min(parent.width - 120, sourceSize.width > 0 ? sourceSize.width : parent.width - 120)
        height: Math.min(parent.height - 120, sourceSize.height > 0 ? sourceSize.height : parent.height - 120)
        source: {
            if (root._currentUrl.length === 0) return ""
            var base = (root._attempt >= 2 && root._fallbackUrl.length > 0)
                       ? root._fallbackUrl : root._currentUrl
            if (root._attempt === 0) return base
            return base + (base.indexOf("?") >= 0 ? "&" : "?") + "r=" + root._attempt
        }
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: true
        smooth: true

        MouseArea {
            anchors.fill: parent
            onClicked: {}
            onWheel: function(wheel) { wheel.angleDelta.y < 0 ? root.next() : root.prev() }
        }
    }

    Timer {
        interval: root._attempt < 4 ? 2500 : 15000
        running: root.shown && root._currentUrl.length > 0 && bigImage.status === Image.Error
        repeat: true
        onTriggered: root._attempt++
    }


    Text {
        anchors.centerIn: parent
        text: "…"
        color: "#8590A2"
        font.pixelSize: 28
        visible: bigImage.status === Image.Loading
    }


    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 24
        width: 40; height: 40; radius: 20
        color: closeMouse.containsMouse ? "#7E2630" : "#60000000"
        Behavior on color { ColorAnimation { duration: 120 } }
        Text { anchors.centerIn: parent; text: "✕"; color: "#F4F6FA"; font.pixelSize: 16; font.bold: true }
        MouseArea {
            id: closeMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.close()
        }
    }


    Rectangle {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 24
        width: 48; height: 72; radius: 10
        visible: root.urls.length > 1
        color: prevBig.containsMouse ? "#B0000000" : "#60000000"
        Behavior on color { ColorAnimation { duration: 120 } }
        Text { anchors.centerIn: parent; text: "‹"; color: "#F4F6FA"; font.pixelSize: 32; font.bold: true }
        MouseArea {
            id: prevBig
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.prev()
        }
    }
    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 24
        width: 48; height: 72; radius: 10
        visible: root.urls.length > 1
        color: nextBig.containsMouse ? "#B0000000" : "#60000000"
        Behavior on color { ColorAnimation { duration: 120 } }
        Text { anchors.centerIn: parent; text: "›"; color: "#F4F6FA"; font.pixelSize: 32; font.bold: true }
        MouseArea {
            id: nextBig
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.next()
        }
    }


    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        spacing: 10
        visible: root.urls.length > 1

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6
            Repeater {
                model: root.urls.length
                delegate: Rectangle {
                    required property int index
                    width: 10; height: 10; radius: 5
                    color: root.index === index ? "#FFFFFF" : "#55FFFFFF"
                    Behavior on color { ColorAnimation { duration: 120 } }
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.index = index
                    }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: (root.index + 1) + " / " + root.urls.length
            color: "#B9C1CE"
            font.pixelSize: 12
        }
    }
}



