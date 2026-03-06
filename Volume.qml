import QtQuick
import QtQuick.Controls

Item {
    width: 24
    height: 24

    signal seekRequested(real PositionVolume)

    property real audioVolume: volumeSlider.value
    property bool audioMuted: false 

    Button {
        id: volumeButton
        onClicked: audioMuted = !audioMuted
        icon.source: {
            if(audioVolume === 0 || audioMuted)
                return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_off.svg"
            if(audioVolume < 0.33)
                return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_mute.svg"
            if(audioVolume < 0.66)
                return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_down.svg"
            return "qrc:/qt/qml/Musync/assets/imagenes/audio/volume_up.svg"
        }
    }

    Slider {
        id: volumeSlider
        from: 0
        to: 1
        value: 0.5
        onValueChanged: seekRequested(value)
    }

}
