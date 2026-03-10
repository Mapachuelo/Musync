import QtQuick
import QtQuick.Controls

Item {
    width: 200
    height: 40

    signal seekRequested(real positionVolume)

    property real audioVolume: volumeSlider.value
    property bool audioMuted: false

    Row {
        anchors.fill: parent
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter

        Button {
            id: volumeButton
            onClicked: audioMuted = !audioMuted
            icon.source: {
                if(audioVolume === 0 || audioMuted) return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_off.svg";
                if(audioVolume < 0.33) return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_mute.svg";
                if(audioVolume < 0.66) return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_down.svg";
                return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_up.svg";
            }
        }

        Slider {
            id: volumeSlider
            width: 120
            anchors.verticalCenter: parent.verticalCenter
            from: 0
            to: 1
            value: 0.5
            onValueChanged: seekRequested(value)

            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 120
                implicitHeight: 4
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: Colors.surfaceColor

                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    color: Colors.sliderFillColor
                    radius: 2
                }
            }

            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 12
                implicitHeight: 12
                radius: 6
                color: volumeSlider.pressed ? Colors.sliderHandlePressedColor : Colors.sliderHandleColor
            }
        }
    }
}
