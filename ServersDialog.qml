import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Item {
    id: root
    visible: false
    z: 50

    signal closed()

    function open() { root.visible = true }
    function close() { root.visible = false; root.closed() }


    Rectangle {
        anchors.fill: parent
        color: "#B4000000"
        MouseArea { anchors.fill: parent; onClicked: root.close() }
    }


    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width - 80, 760)
        height: Math.min(parent.height - 80, 480)
        radius: 16
        color: "#0F1622"
        border.width: 1
        border.color: "#1F2C40"

        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "Выбор сервера"
                    color: "#F1F4FA"
                    font.pixelSize: 18
                    font.bold: true
                }
                Rectangle {
                    width: 28; height: 28; radius: 8
                    color: closeMouse.containsMouse ? "#7E2630" : "transparent"
                    Text { anchors.centerIn: parent; text: "✕"; color: "#B9C1CE"; font.pixelSize: 12 }
                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }


            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                spacing: 0
                Text { Layout.preferredWidth: 210; text: "Сервер";  color: "#7C8899"; font.pixelSize: 11; font.bold: true; font.letterSpacing: 0.8 }
                Text { Layout.preferredWidth: 150; text: "Статус";  color: "#7C8899"; font.pixelSize: 11; font.bold: true; font.letterSpacing: 0.8 }
                Text { Layout.preferredWidth: 130; text: "Онлайн";  color: "#7C8899"; font.pixelSize: 11; font.bold: true; font.letterSpacing: 0.8 }
                Text { Layout.preferredWidth: 90;  text: "Пинг";    color: "#7C8899"; font.pixelSize: 11; font.bold: true; font.letterSpacing: 0.8 }
                Item { Layout.fillWidth: true }
            }

            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#1B2635" }


            ListView {
                id: srvList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: ServersModel.items
                spacing: 4

                delegate: Rectangle {
                    required property int index
                    required property var modelData
                    width: srvList.width
                    height: 46
                    radius: 8
                    color: ServersModel.selectedIndex === index ? "#182232"
                         : (rowMouse.containsMouse ? "#131C29" : "transparent")

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 2
                        anchors.rightMargin: 2
                        spacing: 0

                        Text {
                            Layout.preferredWidth: 210
                            text: modelData.name
                            color: "#EAEFF7"
                            font.pixelSize: 13
                        }

                        RowLayout {
                            Layout.preferredWidth: 150
                            spacing: 8
                            Rectangle {
                                width: 8; height: 8; radius: 4
                                color: {
                                    switch (modelData.status) {
                                    case "online":  return "#22B36A"
                                    case "medium":  return "#E5B657"
                                    case "full":    return "#E56765"
                                    case "offline": return "#6E7A8C"
                                    default:        return "#6E7A8C"
                                    }
                                }
                            }
                            Text {
                                text: {
                                    switch (modelData.status) {
                                    case "online":  return "Онлайн"
                                    case "medium":  return "Средняя загрузка"
                                    case "full":    return "Высокая загрузка"
                                    case "offline": return "Оффлайн"
                                    default: return ""
                                    }
                                }
                                color: "#C7CFDA"
                                font.pixelSize: 12
                            }
                        }

                        Text {
                            Layout.preferredWidth: 130
                            text: modelData.online + " / " + modelData.capacity
                            color: "#C7CFDA"
                            font.pixelSize: 12
                        }

                        Text {
                            Layout.preferredWidth: 90
                            text: modelData.ping < 0 ? "—" : modelData.ping + " ms"
                            color: "#C7CFDA"
                            font.pixelSize: 12
                        }


                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Item { Layout.fillWidth: true }
                            Repeater {
                                model: 4
                                delegate: Rectangle {
                                    required property int index
                                    width: 4
                                    height: 6 + index * 3
                                    radius: 1
                                    color: {
                                        var p = modelData.ping
                                        if (p < 0) return "#2A3346"
                                        var strong = 4 - Math.min(3, Math.floor(p / 40))
                                        var col = p < 40 ? "#22B36A" : (p < 80 ? "#E5B657" : "#E56765")
                                        return (index < strong) ? col : "#2A3346"
                                    }
                                }
                            }
                            Item { width: 4 }
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: modelData.status === "offline" ? Qt.ArrowCursor : Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.status !== "offline")
                                ServersModel.select(index)
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 130
                    radius: 10
                    color: refreshMouse.containsMouse ? "#1B2434" : "#131B27"
                    border.width: 1
                    border.color: "#26364A"
                    Text {
                        anchors.centerIn: parent
                        text: ServersModel.refreshing ? "Обновление…" : "Обновить"
                        color: "#EAEFF7"
                        font.pixelSize: 12
                    }
                    MouseArea {
                        id: refreshMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ServersModel.refresh()
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 130
                    radius: 10
                    color: pickMouse.containsMouse ? Qt.lighter(AppSettings.accentColor, 1.08) : AppSettings.accentColor
                    Text {
                        anchors.centerIn: parent
                        text: "Выбрать"
                        color: "#0B0E15"
                        font.pixelSize: 13
                        font.bold: true
                    }
                    MouseArea {
                        id: pickMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }
        }
    }
}



