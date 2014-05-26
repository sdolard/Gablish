import QtQuick 2.2
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import Qt.labs.settings 1.0

import "utils.js" as Utils

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 640
    height: 480
    title: qsTr("Test")
    statusBar: StatusBar {
        id: sb
        RowLayout {
            Label {
                id: labSb
                text: settingsMP.source
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
        settingsMP.volume = playMusic.volume
        settingsMP.source = playMusic.source
    }
    Component.onCompleted: {
        console.log(settingsMP.source)
        playMusic.source = Qt.resolvedUrl(settingsMP.source)
        playMusic.play()
    }

    Row {
        id: rowButtons
        spacing: 2
        height: 80

        Button {
            width: 80
            height: 80
            text: "Quit"
            onClicked: Qt.quit();
        }

        //Audio {
        MediaPlayer {
            id: playMusic
            //autoLoad: true
            volume: settingsMP.volume
            //source: settingsMP.source
            onError: {
                if (error == 2 /*QMediaPlayer::FormatError*/) {
                    console.log('The format of a media resource isn\'t (fully) supported. Playback may still be possible, but without an audio or video component.')
                }
                labSb.text = errorString
            }
            onPlaying: console.log('Playing ', playMusic.source)
            onStopped: console.log('Stopped')
            onPlaybackStateChanged: {
                switch(playbackState) {
                case 0: break;
                case MediaPlayer.PlayingState:
                    console.log('State:', 'PlayingState');
                    console.log('duration: ', playMusic.duration)
                    console.log(playMusic.metaData.title)
                    buttonPP.text = "Pause"
                    break;
                case MediaPlayer.PausedState:
                    console.log('State:', 'PausedState');
                    buttonPP.text = "Play"
                    break;
                case MediaPlayer.StoppedState:
                    console.log('State:', 'StoppedState');
                    buttonPP.text = "Play"
                    break;
                default:
                    console.error('Unmanaged playbackState: ', playbackState)
                }
            }
        }


        Button {
            id: buttonPP
            width: 80
            height: 80
            text: "Play"
            onClicked: {
                switch(playMusic.playbackState) {
                case 0: // Never loaded ?
                     playMusic.play()
                     break;
                case MediaPlayer.PlayingState:
                    playMusic.pause()
                    break;
                case MediaPlayer.PausedState:
                    playMusic.play()
                    break;
                case MediaPlayer.StoppedState:
                    playMusic.seek(0)
                    playMusic.play()
                    break;
                default:
                    console.error('Unmanaged playbackState: ', playMusic.playbackState)
                }
            }
        }

        FileDialog {
            id: fileDialog
            title: "Choose a file..."
            onAccepted: {
                playMusic.source = fileDialog.fileUrl
                console.log(fileDialog.fileUrl)
                labSb.text = fileDialog.fileUrl
                playMusic.play();
            }
        }

        Button {
            width: 120
            height: 80
            text: "Open a file"
            onClicked: fileDialog.visible = true
        }
    }

    RowLayout {
        id: rlVolume
        spacing: 2
        anchors.top: rowButtons.bottom

        Slider {
            id: sliderVolume
            Layout.fillWidth: true
            value: settingsMP.volume
            onValueChanged: playMusic.volume = value
        }
        Text {
            id: textVolume
            text: Math.floor(playMusic.volume * 100) + '%'
        }
    }
    RowLayout {
        id: rlPos
        spacing: 2
        anchors.top: rlVolume.bottom

        Slider {
            id: sliderPos
            Layout.fillWidth: true
            maximumValue: playMusic.duration
            property bool sync: false
            onValueChanged: {
                if (!sync) {
                    playMusic.seek(value)
                }
            }
        }
        Connections {
            target: playMusic
            onPositionChanged: {
                sliderPos.sync = true
                sliderPos.value = playMusic.position
                sliderPos.sync = false
            }
        }
        Text {
            id: textPos
            text: Math.floor(playMusic.duration / 1000)
        }
    }


}
