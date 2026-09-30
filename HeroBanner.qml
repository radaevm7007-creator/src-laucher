import QtQuick
import QtQuick.Effects
Item {
    id: root










    property string imageSource: {
        var id = AppSettings.selectedClientId
        var list = ManifestManager.clients
        for (var i = 0; i < list.length; ++i)
            if (list[i].id === id && list[i].coverUrl && list[i].coverUrl.length > 0)
                return list[i].coverUrl
        return (AssetCache && AssetCache.readyCount >= 0 && AssetCache.hasAsset("hero_bg.jpg"))
                 ? "image://assets/hero_bg.jpg" : ""
    }
    property int radius: 16
    property int _attempt: 0
    onImageSourceChanged: _attempt = 0
    readonly property string _fallbackSource: (PhotoStore && root.imageSource && root.imageSource.length > 0)
                                             ? PhotoStore.fallbackUrlFor(root.imageSource) : ""


    Rectangle {
        id: shape
        anchors.fill: parent
        radius: root.radius
        color: "white"
        visible: false
        // В software-рендере слой-маска не рисуется и выкидывает весь контент.
        layer.enabled: !SoftwareRender
    }


    Item {
        id: content
        anchors.fill: parent
        layer.enabled: !SoftwareRender
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: shape
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.5
        }


        Rectangle {
            anchors.fill: parent
            visible: bg.status !== Image.Ready
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#0E1B33" }
                GradientStop { position: 0.55; color: "#0A1122" }
                GradientStop { position: 1.0; color: "#070A14" }
            }
        }


        Image {
            id: bg
            anchors.fill: parent
            source: {
                if (!root.imageSource || root.imageSource.length === 0) return ""

                var base = (root._attempt >= 2 && root._fallbackSource.length > 0)
                           ? root._fallbackSource : root.imageSource

                // Встроенные ассеты не понимают cache-buster «?r=N» — провайдер
                // ищет ассет по id с хвостом и не находит (баннер пустовал).
                if (base.indexOf("image://") === 0) return base

                // Совсем ничего не загрузилось — встроенная заглушка вместо пустоты.
                if (root._attempt >= 6) {
                    return (AssetCache && AssetCache.readyCount >= 0
                            && AssetCache.hasAsset("hero_bg.jpg"))
                           ? "image://assets/hero_bg.jpg" : ""
                }

                if (root._attempt === 0) return base
                return base + (base.indexOf("?") >= 0 ? "&" : "?") + "r=" + root._attempt
            }
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            cache: true
            sourceSize.width: 900
            visible: true
            scale: hoverMouse.containsMouse ? 1.05 : 1.0
            transformOrigin: Item.Center
            Behavior on scale { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
        }


        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#4A000000" }
                GradientStop { position: 0.5; color: "#00000000" }
                GradientStop { position: 1.0; color: "#90000000" }
            }
        }


        Text {
            anchors.centerIn: parent
            text: "EXCLUSION"
            color: "#FFFFFF"
            font.pixelSize: Math.max(38, Math.min(96, root.width * 0.11))
            font.bold: true
            font.letterSpacing: 6
            style: Text.Raised
            styleColor: "#000000"
        }
    }

    Timer {
        interval: root._attempt < 4 ? 2500 : 15000
        running: root.imageSource.length > 0 && bg.status === Image.Error
        repeat: true
        onTriggered: root._attempt++
    }


    MouseArea {
        id: hoverMouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        z: 5
    }


    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: "transparent"
        border.width: 1
        border.color: "#1A2536"
        z: 10
    }
}
