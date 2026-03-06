import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 400
    height: 30

    property int position: 0
    property int duration: 0

    signal seekRequested(int newPosition)

    Slider {
        id: slider
        anchors.fill: parent
        from: 0
        to: root.duration
        value: root.position

        onMoved: {
            root.seekRequested(slider.value)
        }
    }
}
