import Musync
import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Dialogs

Window {
    // Darle dimensión a la aplicación
    title: qsTr("Musync")
    color: Colors.backgroundColor
    width: 1920
    height: 1080
    visible: true

    // Opción de mouse a click derecho
    /*MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
                       if (mouse.button === Qt.RightButton)
                           contextMenu.popup()
                   }
        onPressAndHold: (mouse) =>{
                        if(mouse.source === Qt.MouseEventNotSynthesized)
                            contextMenu.popup()
                    }
    }

    Menu{
        id: contextMenu
        MenuItem { text: "hola gustavo"}
    }*/

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

    Row {
        anchors.fill: parent

        Rectangle {
            id: sidebar
            width: 300
            height: parent.height
            color: "transparent"

            Rectangle {
                width: 1
                height: parent.height
                color: Colors.surfaceColor
                anchors.right: parent.right
            }

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                Text {
                    text: "Musync"
                    color: "white"
                    font.pixelSize: 32
                    font.bold: false
                }

                Column {
                    spacing: 15
                    width: parent.width

                    component SidebarItem: Row {
                        id: sidebarItem
                        property string iconSrc
                        property string label
                        spacing: 15
                        Rectangle {
                            width: 20
                            height: 20
                            color: "transparent"
                            Image {
                                anchors.fill: parent
                                source: sidebarItem.iconSrc
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        Text {
                            text: sidebarItem.label
                            color: "white"
                            opacity: 0.8
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    SidebarItem { iconSrc: "qrc:/qt/qml/Musync/assets/imagenes/sync.svg"; label: "Sincronizar" }
                    SidebarItem { iconSrc: "qrc:/qt/qml/Musync/assets/imagenes/start.svg"; label: "Inicio" }
                    SidebarItem { iconSrc: "qrc:/qt/qml/Musync/assets/imagenes/search.svg"; label: "Buscar" }
                    SidebarItem { iconSrc: "qrc:/qt/qml/Musync/assets/imagenes/folder.svg"; label: "Carpetas" }
                    SidebarItem { iconSrc: "qrc:/qt/qml/Musync/assets/imagenes/list.svg"; label: "Lista de reproducción" }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: width + 80
                color: "transparent"

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.surfaceColor
                    anchors.top: parent.top
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10

                    Item {
                        width: parent.width - 40
                        height: width

                        VideoOutput {
                            id: videoCover
                            anchors.fill: parent
                            fillMode: VideoOutput.PreserveAspectFit
                            visible: reproductor.hasVideo && coverImage.status !== Image.Ready
                        }

                        Image {
                            id: coverImage
                            source: reproductor.metaData.coverArtUrl || reproductor.metaData.thumbnailImage || ""
                            asynchronous: true
                            cache: true
                            anchors.fill: parent
                            visible: coverImage.status === Image.Ready
                            fillMode: Image.PreserveAspectCrop
                            mipmap: true

                            Rectangle {
                                anchors.fill: parent
                                color: Colors.surfaceColor
                                z: -1
                                visible: coverImage.status !== Image.Ready

                                Image {
                                    source: "qrc:/qt/qml/Musync/assets/imagenes/music.svg"
                                    width: 64
                                    height: 64
                                    anchors.centerIn: parent
                                    opacity: 0.3
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }

                    Column {
                        function getFileName() {
                            var str = reproductor.source.toString()
                            var lastSlash = str.lastIndexOf('/')
                            var lastDot = str.lastIndexOf('.')
                            if (lastSlash === -1) return "Ninguna canción"
                            var name = str.substring(lastSlash + 1, lastDot !== -1 ? lastDot : str.length)
                            return decodeURIComponent(name)
                        }

                        Text {
                            text: {
                                if (reproductor.source.toString() === "") return "Canción"
                                return reproductor.metaData.title ? reproductor.metaData.title : parent.getFileName()
                            }
                            color: "white"
                            font.pixelSize: 18
                            width: parent.width
                            elide: Text.ElideRight
                        }

                        Text {
                            text: {
                                if (reproductor.source.toString() === "") return "Artista"
                                return reproductor.metaData.albumArtist || reproductor.metaData.contributingArtist || reproductor.metaData.author || "Artista"
                            }
                            color: "white"
                            opacity: 0.6
                            font.pixelSize: 14
                            width: parent.width
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }

        Rectangle {
            width: parent.width - sidebar.width
            height: parent.height
            color: "transparent"

            ScrollView {
                id: mainScroll
                anchors.top: parent.top
                anchors.bottom: playerControls.top
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true

                Column {
                    width: mainScroll.availableWidth
                    spacing: 40
                    padding: 40

                    /*ScrollView {
                        width: parent.width
                        contentWidth: artistsRow.width
                        clip: true
                        Row {
                            id: artistsRow
                            spacing: 30
                            Repeater {
                                model: 5
                                Column {
                                    spacing: 10
                                    Rectangle {
                                        width: 150
                                        height: 150
                                        radius: 75
                                        color: Colors.surfaceColor
                                    }
                                    Text {
                                        text: "Artista"
                                        color: "white"
                                        opacity: 0.8
                                        font.pixelSize: 18
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }*/

                    /*ScrollView {
                        width: parent.width
                        contentWidth: albumsRow.width
                        clip: true
                        anchors.topMargin: 20
                        Row {
                            id: albumsRow
                            spacing: 30
                            Repeater {
                                model: 4
                                Column {
                                    spacing: 10
                                    Rectangle {
                                        width: 200
                                        height: 200
                                        color: Colors.surfaceColor
                                        radius: 10
                                    }
                                    Text {
                                        text: "Album"
                                        color: "white"
                                        opacity: 0.8
                                        font.pixelSize: 18
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }*/
                }
            }

            Rectangle {
                id: playerControls
                width: parent.width
                height: 130
                anchors.bottom: parent.bottom
                color: "transparent"

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.surfaceColor
                    anchors.top: parent.top
                }

                Item {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: progressBarArea.top

                    Row {
                        anchors.centerIn: parent
                        spacing: 20

                        Button {
                            icon.source: "qrc:/qt/qml/Musync/assets/imagenes/skip_previus.svg"
                            icon.width: 32
                            icon.height: 32
                            background: Item {}
                            onClicked: if(reproductor.position > 0) reproductor.position -= 5000
                        }

                        Button {
                            icon.source: reproductor.playing ? "qrc:/qt/qml/Musync/assets/imagenes/pause.svg" : "qrc:/qt/qml/Musync/assets/imagenes/play.svg"
                            icon.width: 36
                            icon.height: 36
                            background: Item {}
                            onClicked: reproductor.playing ? reproductor.pause() : reproductor.play()
                        }

                        Button {
                            icon.source: "qrc:/qt/qml/Musync/assets/imagenes/skip_next.svg"
                            icon.width: 32
                            icon.height: 32
                            background: Item {}
                            onClicked: if(reproductor.position < reproductor.duration) reproductor.position += 5000
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 15

                        Button {
                            icon.source: "qrc:/qt/qml/Musync/assets/imagenes/folder.svg"
                            icon.width: 20
                            icon.height: 20
                            background: Item {}
                            onClicked: buscador_archivos.open()
                        }

                        Volume {
                            id: audio
                            onSeekRequested: (positionVolume) => reproductor.audioOutput.volume = positionVolume
                        }
                    }
                }

                Item {
                    id: progressBarArea
                    width: parent.width - 80
                    height: 30
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 15
                    anchors.horizontalCenter: parent.horizontalCenter

                    Barra_tiempo {
                        id: barra
                        width: parent.width
                        anchors.centerIn: parent
                        position: reproductor.position
                        duration: reproductor.duration
                        onSeekRequested: (newPosition) => reproductor.position = newPosition
                    }
                }
            }
        }
    }
    }
