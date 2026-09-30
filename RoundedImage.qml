import QtQuick
import QtQuick.Effects
Item {
    id: root
    property string source: ""
    property int radius: 12
    property int fillMode: Image.PreserveAspectCrop
    property bool ready: img.status === Image.Ready



    property int fadeMs: 220





    property bool asyncLoad: true
    default property alias fallbackContent: fallbackHost.data



    property int _attempt: 0
    onSourceChanged: _attempt = 0
    readonly property string _fallbackSource: (PhotoStore && root.source && root.source.length > 0)
                                             ? PhotoStore.fallbackUrlFor(root.source) : ""


    Rectangle {
        id: shape
        anchors.fill: parent
        radius: root.radius
        color: "white"
        visible: false
        layer.enabled: true
    }


    Item {
        id: content
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: shape
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.5
        }




        Item {
            id: fallbackHost
            anchors.fill: parent
            visible: img.opacity < 1
        }


        Image {
            id: img
            anchors.fill: parent
            fillMode: root.fillMode
            asynchronous: root.asyncLoad
            cache: true
            smooth: true


            sourceSize.width: 640
            visible: root.source.length > 0
            opacity: root.ready ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: root.fadeMs; easing.type: Easing.OutCubic } }
            source: {
                if (!root.source || root.source.length === 0) return ""
                var base = (root._attempt >= 2 && root._fallbackSource.length > 0)
                           ? root._fallbackSource : root.source
                if (root._attempt === 0) return base

                return base + (base.indexOf("?") >= 0 ? "&" : "?")
                       + "r=" + root._attempt
            }
        }
    }






    Timer {
        interval: root._attempt < 4 ? 2500 : 15000
        running: root.source.length > 0 && img.status === Image.Error
        repeat: true
        onTriggered: root._attempt++
    }
}



