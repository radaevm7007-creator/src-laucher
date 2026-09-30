import QtQuick
import QtQuick.Controls
ComboBox {
    id: control
    property color accent: AppSettings.accentColor

    implicitHeight: 30
    font.pixelSize: 12

    background: Rectangle {
        radius: 8
        color: control.pressed || control.popup.visible ? "#141E2C" : "#0E1725"
        border.width: 1
        border.color: control.popup.visible ? "#26364A" : "#1B2635"
        Behavior on color { ColorAnimation { duration: 130 } }
    }

    contentItem: Text {
        leftPadding: 12
        rightPadding: 26
        text: control.displayText
        color: "#DCE3EE"
        font: control.font
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }


    indicator: Canvas {
        x: control.width - width - 10
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 10; height: 6
        Connections {
            target: control
            function onPopupVisibleChanged() { control.indicator.requestPaint() }
        }
        onPaint: {
            var ctx = getContext("2d"); ctx.reset()
            ctx.strokeStyle = "#8590A2"; ctx.lineWidth = 1.5
            ctx.lineCap = "round"; ctx.lineJoin = "round"
            ctx.beginPath()
            ctx.moveTo(1, 1); ctx.lineTo(5, 5); ctx.lineTo(9, 1)
            ctx.stroke()
        }
    }

    delegate: ItemDelegate {
        width: ListView.view ? ListView.view.width : control.width
        height: 30
        required property int index
        required property string modelData
        contentItem: Text {
            text: modelData
            color: index === control.currentIndex ? control.accent : "#C4CCD8"
            font.pixelSize: 12
            font.bold: index === control.currentIndex
            verticalAlignment: Text.AlignVCenter
            leftPadding: 8
            elide: Text.ElideRight
        }
        background: Rectangle {
            radius: 6
            color: hovered ? "#16202E" : "transparent"
        }
    }

    popup: Popup {
        y: control.height + 4
        width: control.width
        padding: 4
        implicitHeight: Math.min(listView.contentHeight + 8, 300)

        background: Rectangle {
            radius: 10
            color: "#0C1420"
            border.width: 1
            border.color: "#26364A"
        }

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            ScrollIndicator.vertical: ScrollIndicator {}
        }
    }
}



