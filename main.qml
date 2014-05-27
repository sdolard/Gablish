import QtQuick 2.2
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import Qt.labs.settings 1.0
import QtQuick.Controls.Styles 1.1

import "qrc:/qml/components/"

//import "utils.js" as Utils

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 640
    height: 480
    title: qsTr("Gablish")
    statusBar: StatusBar {
        id: sb
        RowLayout {
            Label {
                id: labSb
                text: player.title
            }
        }
    }

    Settings {
        id: settingsMP
        category: "MediaPlayer"
        property url source: "No file selected"
        property real volume: 0.5
    }

    Component.onDestruction: {
        settingsMP.volume = player.volume
        settingsMP.source = player.source
    }
    Component.onCompleted: {
        player.source = Qt.resolvedUrl(settingsMP.source)
        player.play()
    }

    Audio {
        id: player
        volume: settingsMP.volume
        readonly property string title: !!metaData.author && !!metaData.title
                                        ? qsTr("%1 - %2").arg(metaData.author).arg(metaData.title)
                                        : metaData.author || metaData.title || source
        onError: console.log(errorString)
        onPlaying: console.log('Playing ', player.source)
        onStopped: console.log('Stopped')
        onPlaybackStateChanged: {
            switch(playbackState) {
            case 0: break;
            case MediaPlayer.PlayingState:
                buttonPP.imageSource = "qrc:/res/pause.png"
                break;
            case MediaPlayer.PausedState:
            case MediaPlayer.StoppedState:
                buttonPP.imageSource = "qrc:/res/play.png"
                break;
            default:
                console.error('Unmanaged playbackState: ', playbackState)
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Choose a file..."
        nameFilters: [qsTr("MP3 files (*.mp3)"), qsTr("All files (*.*)")]
        onAccepted: {
            player.source = fileDialog.fileUrl
            console.log(fileDialog.fileUrl)
            player.play();
        }
    }


    Row {
        y: 10
        x: 10
        id: rowButtons
        spacing: 10
        height: 80

        GabButton {
            imageSource: "qrc:/res/login.png"
            onClicked: Qt.quit();
        }


        GabButton {
            id: buttonPP
            imageSource: "qrc:/res/play.png"
            onClicked: {
                switch(player.playbackState) {
                case 0: // Never loaded ?
                    player.play()
                    break;
                case MediaPlayer.PlayingState:
                    player.pause()
                    break;
                case MediaPlayer.PausedState:
                    player.play()
                    break;
                case MediaPlayer.StoppedState:
                    player.seek(0)
                    player.play()
                    break;
                default:
                    console.error('Unmanaged playbackState: ', player.playbackState)
                }
            }
        }

        GabButton {
            width: 120
            imageSource: "qrc:/res/file.png"
            onClicked: fileDialog.visible = true
        }
    }

    RowLayout {
        id: rlVolume
        spacing: 2
        anchors.top: rowButtons.bottom
        anchors.topMargin: 50

        Slider {
            id: sliderVolume
            Layout.fillWidth: true
            value: settingsMP.volume
            onValueChanged: player.volume = value
        }
        Text {
            id: textVolume
            text: Math.floor(player.volume * 100) + '%'
        }
    }
    RowLayout {
        id: rlPos
        spacing: 2
        anchors.top: rlVolume.bottom

        Slider {
            id: sliderPos
            Layout.fillWidth: true
            maximumValue: player.duration
            property bool sync: false
            onValueChanged: {
                if (!sync) {
                    player.seek(value)
                }
            }
        }
        Connections {
            target: player
            onPositionChanged: {
                sliderPos.sync = true
                sliderPos.value = player.position
                sliderPos.sync = false
            }
        }
        Text {
            id: textPos
            readonly property int posM: Math.floor(player.position / 60000)
            readonly property int posS: Math.round((player.position % 60000) / 1000)
            readonly property int durM: Math.floor(player.duration / 60000)
            readonly property int durS: Math.round((player.duration % 60000) / 1000)
            readonly property string pos: Qt.formatTime(new Date(0, 0, 0, 0, posM, posS), qsTr("mm:ss"))
            readonly property string dur: Qt.formatTime(new Date(0, 0, 0, 0, durM, durS), qsTr("mm:ss"))

            text: qsTr("%1/%2").arg(pos).arg(dur)
        }
    }
}
