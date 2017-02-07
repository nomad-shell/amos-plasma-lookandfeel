import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

FocusScope {
    id: password

    font.pixelSize: 12
//    property alias color: txtMain.color
    property alias borderColor: txtMain.borderColor
    property alias focusColor: txtMain.focusColor
    property alias hoverColor: txtMain.hoverColor
    property alias radius: txtMain.radius
    property alias font: txtMain.font
//    property alias textColor: txtMain.color
    property alias echoMode: txtMain.echoMode
    property alias text: txtMain.text

    property alias image: img.source
    property double imageFadeIn: 300
    property double imageFadeOut: 200


    property alias tooltipEnabled: tooltip.visible
    property alias tooltipText: tooltipText.text
    property alias tooltipFG: tooltipText.color
    property alias tooltipBG: tooltip.color

    signal accepted()

    TextConstants {
        id: textConstants
    }

    CustomTextField {
        id: txtMain
        width: parent.width
        height: parent.height
        font.pixelSize: 14

        echoMode: TextInput.Password

        placeholderText: textConstants.password
        focus: true

        onAccepted: password.accepted()
    }

    Timer {
        interval: 200
        running: true
        onTriggered: password.forceActiveFocus()
    }

    Image {
        id: img
        opacity: 0
//        state: keyboard.capsLock ? "activated" : ""
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit

        smooth: true
        height: parent.height * 0.8

        source: "artwork/warning.svg"
        sourceSize.width: width
        sourceSize.height: height

        anchors.rightMargin: 0.3 * width

        states: [
            State {
                name: "activated"
                PropertyChanges { target: img; opacity: 1; }
            },
            State {
                name: ""
                PropertyChanges { target: img; opacity: 0; }
            }
        ]

        transitions: [
            Transition {
                to: "activated"
                NumberAnimation { target: img; property: "opacity"; from: 0; to: 1; duration: imageFadeIn; }
            },

            Transition {
                to: ""
                NumberAnimation { target: img; property: "opacity"; from: 1; to: 0; duration: imageFadeOut; }
            }
        ]

        MouseArea {
            id: hoverArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.ArrowCursor

            onEntered: {
                tooltip.x = mouseX + img.x + 10
                tooltip.y = mouseY + 10
            }

            onPositionChanged: {
                tooltip.x = mouseX + img.x + 10
                tooltip.y = mouseY + 10
            }
        }
    }

    Rectangle {
        id: tooltip
        color: "lightblue"
        border.color: "black"
        border.width: 1

        width: 1.1 * tooltipText.implicitWidth
        height: 1.4 * tooltipText.implicitHeight
        radius: 2
        opacity: 0

        state: hoverArea.containsMouse && img.state == "activated" ? "activated" : ""

        states: [
            State {
                name: "activated"
                PropertyChanges { target: tooltip; opacity: 1 }
            },
            State {
                name: ""
                PropertyChanges { target: tooltip; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                to: "activated"
                NumberAnimation { target: tooltip; property: "opacity"; from: 0; to: 1; duration: imageFadeIn; }
            },

            Transition {
                to: ""
                NumberAnimation { target: tooltip; property: "opacity"; from: 1; to: 0; duration: imageFadeOut; }
            }
        ]

        Text {
            id: tooltipText
            anchors.centerIn: parent;
            text: textConstants.capslockWarning
        }
    }
}
