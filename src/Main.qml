import Musync
import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Dialogs
import "../moduls"
//import QMediaMetaData

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
            muted: audio.audioMuted
        }
    }

    FileDialog {
        id: buscador_archivos
        title: "Elegir una canción"
        nameFilters: [

            "Archivos de audio (*.mp3 *.flac *.wav *.mp3 *.m4a *.ogg *.opus *.wma *.alac *.aiff)"

            //PAQUETES PARA ARCH LINUX sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
        ]

        onAccepted: {
            reproductor.source = buscador_archivos.currentFile
            reproductor.play()
        }
    }

        Column {

            
        }

        Column {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter 
            spacing: 20

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20 
                visible: reproductor.hasAudio

                VideoOutput {
                    id: videoCover
                    width: 100
                    height: 100
                    fillMode: VideoOutput.PreserveAspectFit
                    visible: reproductor.hasVideo && coverImage.status !== Image.Ready
                }

                Image {
                    id: coverImage
                    source: reproductor.metaData.coverArtUrl || reproductor.extractedCover || ""
                    asynchronous: true
                    cache: true
                    width: 100
                    height: 100
                    visible: coverImage.status === Image.Ready
                    fillMode: Image.PreserveAspectFit
                    mipmap: true

                    Rectangle {
                        anchors.fill: parent
                        color: "#333333"
                        z: -1
                        visible: coverImage.status !== Image.Ready 
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🎵"
                            font.pixelSize: 40
                        }
                    }
                }

                Column {
                    spacing: 5
           
                    function getFileName() {
                        var str = reproductor.source.toString()
                        var lastSlash = str.lastIndexOf('/')
                        var lastDot = str.lastIndexOf('.')
                        if (lastSlash === -1) return "Desconocido"
                        var name = str.substring(lastSlash + 1, lastDot !== -1 ? lastDot : str.length)
                        return decodeURIComponent(name)
                    }

                    Text {
                        text: "<b>Título:</b> " + (reproductor.metaData.title || parent.getFileName())
                        color: "white"
                        font.pixelSize: 16
                        width: 400
                        elide: Text.ElideRight
                    }
                    /*Text {
                        property string artistText: reproductor.metaData.contributingArtist || reproductor.metaData.albumArtist || reproductor.metaData.author || "Desconocido"
                        text: "<b>Artista:</b> " + artistText
                        color: "white"
                        font.pixelSize: 14
                        width: 400
                        elide: Text.ElideRight
                    }
                    Text {
                        property string albumText: reproductor.metaData.albumTitle || "Desconocido"
                        text: "<b>Álbum:</b> " + albumText
                        color: "white"
                        font.pixelSize: 14
                        width: 400
                        elide: Text.ElideRight
                    }
                    Text {
                        property string fileUrl: reproductor.source.toString()
                        text: "<b>Tipo:</b> " + (fileUrl !== "" ? fileUrl.substring(fileUrl.lastIndexOf('.') + 1).toUpperCase() : "Desconocido")
                        color: "white"
                        font.pixelSize: 14
                    }*/
                }
            }

            Text {
                visible: !reproductor.hasAudio
                text: "Ninguna canción cargada"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Barra_tiempo {
                id: barra
                position: reproductor.position
                duration: reproductor.duration
                anchors.horizontalCenter: parent.horizontalCenter
                onSeekRequested: (newPosition) => {
                    reproductor.position = newPosition
                }
            }

            Row {
                spacing: 50
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    icon.source: "qrc:/qt/qml/Musync/assets/imagenes/folder.svg"
                    icon.width: 24
                    icon.height: 24
                    onClicked: buscador_archivos.open()
                    anchors.verticalCenter: parent.verticalCenter
                }

                Row {
                    spacing: 20
                    anchors.verticalCenter: parent.verticalCenter

                    Button {
                        icon.source: "qrc:/qt/qml/Musync/assets/imagenes/skip_previus.svg"
                        icon.width: 24
                        icon.height: 24
                        onClicked: {
                            if(reproductor.position > 0) reproductor.position -= 5000
                        }
                    }

                    Button {
                        icon.source: reproductor.playing ?  "qrc:/qt/qml/Musync/assets/imagenes/pause.svg" : "qrc:/qt/qml/Musync/assets/imagenes/play.svg"
                        icon.width: 24
                        icon.height: 24

                        onClicked: {
                            if(reproductor.playing){
                                reproductor.pause()
                            }else{
                                reproductor.play()
                            }
                        }
                    }

                    Button {
                        icon.source: "qrc:/qt/qml/Musync/assets/imagenes/skip_next.svg"
                        icon.width: 24
                        icon.height: 24
                        onClicked: {
                            if(reproductor.position < reproductor.duration) reproductor.position += 5000
                        }
                    }
                }

                Volume {
                    id: audio
                    anchors.verticalCenter: parent.verticalCenter
                    onSeekRequested: (positionVolume) => reproductor.audioOutput.volume = positionVolume
                }       
            }
        }
    }
