import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Dialogs

Window {
    title: qsTr("Musync")
    width: 1920
    height: 1080
    visible: true

    MediaPlayer {
        id: reproductor
        audioOutput: AudioOutput {
            volume: 1.0
        }
    }

    FileDialog {
        id: buscador_archivos
        title: "Elegir una canción"
        nameFilters: ["Archivos de audio (*.mp3 *.wav *.ogg)"]
        onAccepted: {
            reproductor.source = selectedFile
            reproductor.play()
        }
    }

        Column {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter 
            spacing: 20

            Text {
                text: reproductor.hasAudio ? "Canción cargada " : "Ninguna canción cargada" 
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: 20

                Button {
                    text: "Cargar canción"
                    onClicked: buscador_archivos.open()
                }

                Button {
                    text: "Play"
                    onClicked: reproductor.play()
                }

                Button {
                    text: "Pausa"
                    onClicked: reproductor.pause()
                }
            }
        }

}
