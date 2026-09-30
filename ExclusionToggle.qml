import QtQuick
Row {
    id: root
    property bool value: false
    signal changed(bool newValue)
    spacing: 4

    Rectangle {
        width: 96; height: 32
        radius: 8
        color: !root.value ? AppSettings.accentColor
                           : (offMouse.containsMouse ? "#1F2C40" : "#1A2434")
        Behavior on color { ColorAnimation { duration: 120 } }
        Text {
            anchors.centerIn: parent
            text: (AppI18n.language, AppI18n.t("toggle.off"))
            color: !root.value ? "#08131F" : "#B9C1CE"
            font.pixelSize: 11
            font.bold: !root.value
        }
        MouseArea {
            id: offMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: if (root.value) { root.value = false; root.changed(false) }
        }
    }
    Rectangle {
        width: 96; height: 32
        radius: 8
        color: root.value ? AppSettings.accentColor
                          : (onMouse.containsMouse ? "#1F2C40" : "#1A2434")
        Behavior on color { ColorAnimation { duration: 120 } }
        Text {
            anchors.centerIn: parent
            text: (AppI18n.language, AppI18n.t("toggle.on"))
            color: root.value ? "#08131F" : "#B9C1CE"
            font.pixelSize: 11
            font.bold: root.value
        }
        MouseArea {
            id: onMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: if (!root.value) { root.value = true; root.changed(true) }
        }
    }
}



