import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Button {
    property url imageSource: ""
    antialiasing: true

    style: ButtonStyle {
        background: Rectangle {
            SequentialAnimation on rotation {
                loops: Animation.Infinite
                RotationAnimation {
                    from: -15
                    to: 15
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
                RotationAnimation {
                    from: 15
                    to: -15
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
            }
            implicitWidth: 80
            implicitHeight: 80
            border.width: control.activeFocus ? 2 : 1
            border.color: "#888"
            radius: 4
            gradient: Gradient {
                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
            }
            Image {
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                source: imageSource
            }
        }
    }
}
