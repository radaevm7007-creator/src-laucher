import QtQuick
import QtQuick.Layouts
Rectangle {
    id: row


    required property var info

    property string titlePrefix: ""

    property string textInstalled: ""
    property string textMissing: ""
    property string textGet: ""
    property string textDelete: ""

    Layout.fillWidth: true
    Layout.preferredHeight: 56
    radius: 10
    color: "#0B131F"
    border.width: 1
    border.color: "#1B2635"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 12
        spacing: 12



        ColumnLayout {
            spacing: 2
            Text {
                text: (row.titlePrefix ? row.titlePrefix + " " : "")
                      + (row.info.version || row.info.id)
                color: "#F1F4FA"
                font.pixelSize: 13
                font.bold: true
            }
            Text {
                text: {
                    var who = row.info.vendor || row.info.id
                    if (row.info.downloading) return who + " · " + RuntimeManager.statusText
                    return who + " · " + (row.info.installed ? row.textInstalled : row.textMissing)
                }
                color: row.info.installed ? "#22B36A" : "#7C8899"
                font.pixelSize: 10
            }
        }


        Rectangle {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 8
            radius: 4
            color: "#1A2434"
            visible: row.info.downloading
            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.max(0, Math.min(1, RuntimeManager.progress))
                radius: 4
                color: AppSettings.accentColor
                Behavior on width { NumberAnimation { duration: 150 } }
            }
        }


        Rectangle {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 32
            radius: 8
            visible: !row.info.downloading && !row.info.installed
            color: getMouse.containsMouse ? Qt.lighter(AppSettings.accentColor, 1.12)
                                          : AppSettings.accentColor
            Behavior on color { ColorAnimation { duration: 120 } }

            Text {
                anchors.centerIn: parent
                text: row.textGet
                color: "#08131F"
                font.pixelSize: 11
                font.bold: true
            }
            MouseArea {
                id: getMouse
                anchors.fill: parent
                hoverEnabled: true
                enabled: !RuntimeManager.busy
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: RuntimeManager.ensure(row.info.id)
            }
        }



        Rectangle {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 32
            radius: 8
            visible: !row.info.downloading && row.info.installed
            color: delMouse.containsMouse ? "#7E2630" : "#131B27"
            border.width: 1
            border.color: delMouse.containsMouse ? "#7E2630" : "#26364A"
            Behavior on color { ColorAnimation { duration: 120 } }

            Text {
                anchors.centerIn: parent
                text: row.textDelete
                color: delMouse.containsMouse ? "#FFE5E9" : "#B9C1CE"
                font.pixelSize: 11
                font.bold: true
            }
            MouseArea {
                id: delMouse
                anchors.fill: parent
                hoverEnabled: true
                enabled: !RuntimeManager.busy
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: RuntimeManager.removeRuntime(row.info.id)
            }
        }


        Item { Layout.fillWidth: true }
    }
}



