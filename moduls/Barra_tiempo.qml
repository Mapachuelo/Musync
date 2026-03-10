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

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: slider.availableWidth
            height: implicitHeight
            radius: 2
            color: Colors.surfaceColor

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: Colors.sliderFillColor
                radius: 2
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 12
            implicitHeight: 12
            radius: 6
            color: slider.pressed ? Colors.sliderHandlePressedColor : Colors.sliderHandleColor
        }
    }
}
