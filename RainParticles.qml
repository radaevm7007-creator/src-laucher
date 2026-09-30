import QtQuick
Item {
    id: root
    property int count: 120
    property real angle: 14

    clip: true

    Repeater {
        model: root.count
        delegate: Item {
            id: drop
            required property int index


            property real seed: (index * 0.61803398875) % 1
            property real len: 12 + (index * 13 % 24)
            property real startX: seed * (root.width + 160) - 80
            property real dur: 620 + (index * 197 % 760)
            property real slope: Math.tan(root.angle * Math.PI / 180)

            width: 2
            height: len





            rotation: -root.angle

            opacity: 0.16 + (index * 17 % 42) / 100


            Rectangle {
                anchors.fill: parent
                radius: 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#00AFC6E4" }
                    GradientStop { position: 1.0; color: "#C8D6EBFF" }
                }
            }


            x: startX + y * slope

            SequentialAnimation on y {
                loops: Animation.Infinite
                running: root.visible

                PauseAnimation { duration: (index * 53) % 900 }
                NumberAnimation {
                    from: -drop.len - 20
                    to: root.height + 40
                    duration: drop.dur
                    easing.type: Easing.Linear
                }
            }
        }
    }
}



