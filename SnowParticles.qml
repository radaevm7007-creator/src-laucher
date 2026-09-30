import QtQuick
Item {
    id: root
    property int count: 52
    clip: true

    Repeater {
        model: root.count
        delegate: Rectangle {
            required property int index
            property real seed: (index * 0.61803398875) % 1
            property real drift: 20 + ((index * 37) % 90)
            property real baseX: seed * Math.max(1, root.width - width)
            width: 2 + ((index * 11) % 4)
            height: width
            radius: width / 2
            color: "#D8ECFF"
            opacity: 0.12 + ((index * 17) % 30) / 100
            x: baseX
            y: -20 - ((index * 31) % Math.max(1, root.height))

            SequentialAnimation on y {
                loops: Animation.Infinite
                running: root.visible
                NumberAnimation {
                    from: -30
                    to: root.height + 30
                    duration: 6500 + ((index * 173) % 7000)
                    easing.type: Easing.Linear
                }
            }

            SequentialAnimation on x {
                loops: Animation.Infinite
                running: root.visible
                NumberAnimation { to: baseX + drift; duration: 2600 + ((index * 97) % 2400); easing.type: Easing.InOutSine }
                NumberAnimation { to: baseX; duration: 2600 + ((index * 97) % 2400); easing.type: Easing.InOutSine }
            }
        }
    }
}



