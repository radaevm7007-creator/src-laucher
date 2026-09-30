import QtQuick
import QtQuick.Controls
// Поле поиска в едином стиле (как в разделе «Клиенты»): тёмный скруглённый бокс,
// иконка-лупа, безрамочный ввод, крестик очистки.
Rectangle {
    id: box
    property alias text: field.text
    property string placeholder: ""
    signal edited(string value)

    implicitHeight: 34
    radius: 8
    color: field.activeFocus ? "#141E2C" : "#0E1725"
    border.width: 1
    border.color: field.activeFocus ? "#26364A" : "#1B2635"
    Behavior on color { ColorAnimation { duration: 140 } }

    Canvas {
        id: icon
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: 14; height: 14
        onPaint: {
            var c = getContext("2d"); c.reset()
            c.strokeStyle = "#8590A2"; c.lineWidth = 1.5; c.lineCap = "round"
            c.beginPath(); c.arc(6, 6, 4.2, 0, Math.PI * 2); c.stroke()
            c.beginPath(); c.moveTo(9.3, 9.3); c.lineTo(13, 13); c.stroke()
        }
    }

    TextField {
        id: field
        anchors.left: icon.right
        anchors.right: clr.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 8
        anchors.rightMargin: 4
        height: parent.height
        padding: 0
        color: "#F1F4FA"
        font.pixelSize: 12
        verticalAlignment: TextInput.AlignVCenter
        selectByMouse: true
        background: null
        placeholderText: box.placeholder
        placeholderTextColor: "#556275"
        onTextChanged: box.edited(text)
    }

    Text {
        id: clr
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "×"
        font.pixelSize: 16
        color: clrMouse.containsMouse ? "#EAEFF7" : "#7C8899"
        visible: field.text.length > 0
        MouseArea {
            id: clrMouse
            anchors.fill: parent
            anchors.margins: -6
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: field.text = ""
        }
    }
}



