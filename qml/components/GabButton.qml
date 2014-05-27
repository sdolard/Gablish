import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Button {
    property url imageSource: ""

    style: ButtonStyle {
        background: Rectangle {
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
