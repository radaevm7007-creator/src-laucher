import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
Item {
    id: root
    property var hostWindow
    property int currentIndex: 0
    signal navigate(int index)

    height: 56



    readonly property string telegramPath:"M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z"

    MouseArea {
        anchors.fill: parent
        onPressed: if (hostWindow) hostWindow.startSystemMove()
    }

    Image {
        id: logo
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        width: 34
        height: 34
        source: "qrc:/icons/data/logo.png"
        sourceSize.width: 128
        sourceSize.height: 128
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: true
        mipmap: true
        visible: logo.status === Image.Ready
        z: 2
    }




    Item {
        id: tabsHost
        anchors.centerIn: parent
        width: tabsRow.width
        height: root.height
        z: 2

        Row {
            id: tabsRow
            spacing: 34

            Repeater {
                id: tabsRepeater

                model: (AppI18n.language, [ AppI18n.t("nav.home"), AppI18n.t("nav.news"), AppI18n.t("nav.clients"), AppI18n.t("nav.configs"), AppI18n.t("nav.settings") ])
                delegate: Item {
                    id: tab
                    required property int index
                    required property string modelData
                    width: navText.implicitWidth + 4
                    height: root.height


                    readonly property real underlineWidth: navText.implicitWidth + 8



                    function syncIndicator() {
                        if (root.currentIndex !== tab.index) return
                        indicator.targetX = tab.x + (tab.width - tab.underlineWidth) / 2
                        indicator.targetW = tab.underlineWidth
                    }

                    onXChanged: syncIndicator()
                    onWidthChanged: syncIndicator()
                    Component.onCompleted: syncIndicator()

                    Connections {
                        target: root
                        function onCurrentIndexChanged() { tab.syncIndicator() }
                    }

                    Text {
                        id: navText
                        anchors.centerIn: parent
                        text: modelData
                        color: root.currentIndex === index ? "#F4F6FA" : (navMouse.containsMouse ? "#C5CBD7" : "#8590A2")
                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 1.2
                        Behavior on color { ColorAnimation { duration: 220 } }
                    }

                    MouseArea {
                        id: navMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.navigate(index)
                    }
                }
            }
        }

        Rectangle {
            id: indicator


            property real targetX: 0
            property real targetW: 0

            x: targetX
            width: targetW
            height: 2
            radius: 1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            color: AppSettings.accentColor
            visible: width > 0

            Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0
        z: 3




        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "v" + LauncherVersion
            color: "#6B7787"
            font.pixelSize: 10
            font.bold: true
        }
        Item { width: 8; height: 1 }

        Repeater {
            model: [
                { kind: "telegram", url: (typeof ServerSync !== "undefined" ? ServerSync.telegramUrl : "") }
            ]
            delegate: Rectangle {
                required property var modelData
                readonly property bool has: modelData.url && modelData.url.length > 0
                width: 34
                height: 34
                radius: 8
                color: (has && socMouse.containsMouse) ? "#151E2B" : "transparent"

                Shape {
                    id: icoShape
                    anchors.centerIn: parent
                    width: 20; height: 20
                    antialiasing: true
                    preferredRendererType: Shape.CurveRenderer
                    opacity: parent.has ? (socMouse.containsMouse ? 1.0 : 0.82) : 0.32

                    transform: Scale { xScale: icoShape.width / 24; yScale: icoShape.height / 24 }
                    ShapePath {
                        fillColor: "#2AABEE"
                        strokeWidth: 0
                        fillRule: ShapePath.WindingFill
                        PathSvg { path: root.telegramPath }
                    }
                }

                MouseArea {
                    id: socMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: parent.has ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: if (parent.has) Qt.openUrlExternally(modelData.url)
                }
            }
        }


        Item { width: 6; height: 1 }

        Repeater {
            model: [{ label: "–", role: "min" }, { label: "✕", role: "close" }]
            delegate: Rectangle {
                required property int index
                required property var modelData
                width: 40; height: 34; radius: 8
                color: winMouse.containsMouse ? (modelData.role === "close" ? "#7E2630" : "#151E2B") : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: modelData.label
                    color: "#B9C1CE"
                    font.pixelSize: modelData.role === "close" ? 12 : 15
                    font.bold: modelData.role !== "close"
                }
                MouseArea {
                    id: winMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (!hostWindow) return
                        if (modelData.role === "min") hostWindow.showMinimized()
                        else hostWindow.close()
                    }
                }
            }
        }
    }
}



