import QtQuick
Rectangle {
    id: root
    property string text: "Кнопка"
    property bool primary: true
    property bool enabled: true
    signal clicked()

    implicitWidth: 140
    implicitHeight: 42
    radius: 10
    color: !enabled ? "#1A2230" : (primary ? AppSettings.accentColor : (mouse.containsMouse ? "#1C2736" : "#151D29"))
    border.width: primary ? 0 : 1
    border.color: "#273345"
    opacity: enabled ? 1.0 : 0.55

    Behavior on color { ColorAnimation { duration: 140 } }
    Behavior on scale { NumberAnimation { duration: 120 } }
    scale: mouse.pressed ? 0.98 : 1.0

    Text {
        anchors.centerIn: parent
        text: root.text
        color: root.primary ? "#08111D" : "#EAF2FF"
        font.pixelSize: 13
        font.weight: Font.DemiBold
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}



