import QtQuick

// Падающие звёзды «★» как в оригинале: глиф звезды + мягкое белое свечение
// и едва заметная дымка акцента (без цветных пятен).
Item {
    id: root
    property int count: 56

    clip: true

    readonly property color tint:
        AppSettings.accentColor ? AppSettings.accentColor : "#8A63F5"

    Repeater {
        model: root.count
        delegate: Item {
            id: star
            required property int index


            property real seed: (index * 0.61803398875) % 1
            property real startX: seed * (root.width + 200) - 100
            property real startY: -40 - ((index * 47) % 300)
            property real slope: 0.42

            // глубина: дальние мельче и тусклее
            readonly property int depth: index % 3
            readonly property real baseSize:
                depth === 0 ? 9 + ((index * 13) % 5)
              : depth === 1 ? 13 + ((index * 13) % 7)
                            : 18 + ((index * 13) % 9)
            readonly property real baseOpacity:
                depth === 0 ? 0.35 : depth === 1 ? 0.55 : 0.85

            width: baseSize * 4
            height: width

            // сама звезда — как в оригинале
            Text {
                anchors.centerIn: parent
                text: "★"
                color: Qt.tint("#FFFFFF", Qt.rgba(root.tint.r, root.tint.g,
                                                  root.tint.b, 0.12))
                opacity: star.baseOpacity
                font.pixelSize: star.baseSize
                font.bold: true
                rotation: -22
            }

            x: startX + (y - startY) * slope
            y: startY

            SequentialAnimation on y {
                loops: Animation.Infinite
                running: root.visible
                NumberAnimation {
                    from: star.startY
                    to: root.height + 40
                    duration: 7500 + ((star.index * 197) % 6500)
                    easing.type: Easing.Linear
                }
            }

            // мерцание (у трети звёзд его нет — так естественнее)
            SequentialAnimation on opacity {
                running: root.visible && index % 3 !== 2
                loops: Animation.Infinite
                alwaysRunToEnd: true
                NumberAnimation {
                    from: 1.0; to: 0.30
                    duration: 1200 + (star.seed * 2400)
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    from: 0.30; to: 1.0
                    duration: 1200 + ((1.0 - star.seed) * 2400)
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
