import Musync
import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Dialogs

Window {
    title: qsTr("Musync")
    color: "#5662f6"
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

            Barra_tiempo {
                id: barra
                position: reproductor.position
                duration: reproductor.duration
                onSeekRequested: (newPosition) => {
                    reproductor.position = newPosition
                }
            }

            Row {
                spacing: 20

                Button {
                    icon.source: "qrc:/qt/qml/Musync/assets/imagenes/folder.svg"
                    icon.width: 24
                    icon.height: 24
                    onClicked: buscador_archivos.open()
                }

                Button {
                    icon.source: "qrc:/qt/qml/Musync/assets/imagenes/play.svg"
                    icon.width: 24
                    icon.height: 24
                    onClicked: reproductor.play()
                }

                Button {
                    icon.source: "qrc:/qt/qml/Musync/assets/imagenes/pause.svg"
                    icon.width: 24
                    icon.height: 24
                    onClicked: reproductor.pause()
                }
            }
        }
}
