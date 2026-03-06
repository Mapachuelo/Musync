import Musync
import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Dialogs

Window {
    title: qsTr("Musync")
    color: Colors.backgroundColor
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
        nameFilters: [

            "Archivos de audio (*.mp3 *.m4a *.ogg *.opus *.wma)",
            "Archivos de macOS (*.alac *.aiff)",
            "Sin perdida de audio (*.flac *.wav)",

            //PAQUETES PARA ARCH LINUX sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
        ]

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
                    icon.source: "qrc:/qt/qml/Musync/assets/imagenes/skip_previus.svg"
                    icon.width: 24
                    icon.height: 24
                    onClicked: {
                        if(reproductor > 0) reproductor--
                    }
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

                Button {
                    icon.source: "qrc:/qt/qml/Musync/assets/imagenes/skip_next.svg"
                    icon.width: 24
                    icon.height: 24
                    onClicked: {
                        if(reproductor < 0 ) reproductor++
                    }
                }
              }


            Volume {
                id: audio
                onSeekRequested: (positionVolume) => reproductor.audioOutput.volume = positionVolume
            }       
            

        }
}
