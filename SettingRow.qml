import QtQuick
import QtQuick.Layouts
Rectangle {
    id: root
    property string title: ""
    property string description: ""

    default property alias rightItems: rightRow.data

    Layout.fillWidth: true
    Layout.preferredHeight: Math.max(60, layoutRow.implicitHeight + 20)
    color: hover.hovered ? "#0E1522" : "transparent"
    radius: 10
    Behavior on color { ColorAnimation { duration: 100 } }

    HoverHandler {
        id: hover
    }

    RowLayout {
        id: layoutRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 16

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: 280
            spacing: 3
            Text {
                Layout.fillWidth: true
                text: root.title
                color: "#F1F4FA"
                font.pixelSize: 14
                font.bold: true
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                text: root.description
                color: "#7C8899"
                font.pixelSize: 10
                wrapMode: Text.WordWrap
                visible: text.length > 0
            }
        }

        Row {
            id: rightRow
            spacing: 8
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        height: 1
        color: "#141C29"
    }
}



