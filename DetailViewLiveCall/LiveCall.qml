import QtQuick 2.0
import Ubuntu.Components 0.1
import "../Widgets" as LocalWidgets
import "../PanelDialer"
import "../"

LocalWidgets.TelephonyPage {
    id: liveCall

    property alias contact: contactWatcher.contact
    property QtObject call: callManager.foregroundCall
    property alias number: contactWatcher.phoneNumber
    property bool onHold: call ? call.held : false
    property bool isSpeaker: call ? call.speaker : false
    property bool isMuted: call ? call.muted : false
    property alias isDtmf: flipable.flipped

    title: call && call.dialing ? "Dialing" : "Duration " + stopWatch.elapsed
    showChromeBar: false

    function endCall() {
        if (call) {
            call.endCall();
        }
    }

    LocalWidgets.StopWatch {
        id: stopWatch
        time: call ? call.elapsedTime : 0
        visible: false
    }

    ContactWatcher {
        id: contactWatcher
        phoneNumber: call ? call.phoneNumber : ""
    }

    Connections {
        target: callManager
        onCallEnded: {
            if (!callManager.hasCalls && telephony.liveCall.loaded) {
                var filterProperty = "phoneNumber";
                var filterValue = contactWatcher.phoneNumber;
                if (contactWatcher.contactId != "") {
                    filterProperty = "contactId";
                    filterValue = contactWatcher.contactId;
                }

                telephony.showCommunication(filterProperty, filterValue, contactWatcher.contactId, true);
                telephony.endCall();
            }
        }
    }

    BackgroundCall {
        id: backgroundCall

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        call: callManager.backgroundCall
        visible: callManager.hasBackgroundCall
    }

    LocalWidgets.Header {
        id: pageHeader
        text: title
    }

    Flipable {
        id: flipable
        anchors {
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        
        property bool flipped: false
        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 0    // the default angle
        }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }

        // avoid events on the wrong view
        onSideChanged: { 
            front.visible = (side == Flipable.Front);
            back.visible = (side == Flipable.Back);
        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 400 }
        }

        front: Item {
            anchors.top: backgroundCall.visible ? backgroundCall.bottom : parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Item {
                id: header
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: units.gu(10)

                UbuntuShape {
                    id: picture

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(2)
                    width: units.gu(6)
                    height: units.gu(6)
                    image: Image {
                        source: contact && contact.avatar != "" ? contact.avatar : "../assets/avatar_messaging.png"
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                TextCustom {
                    id: name

                    anchors.top: picture.top
                    anchors.left: picture.right
                    anchors.leftMargin: units.gu(2)
                    text: contact ? contact.displayLabel : "Unknown Contact"
                    color: "#a0a0a2"
                    fontSize: "large"
                }

                TextCustom {
                    id: number

                    anchors.top: name.bottom
                    anchors.topMargin: units.dp(2)
                    anchors.left: picture.right
                    anchors.leftMargin: units.gu(2)
                    text: liveCall.number
                    color: "#a0a0a2"
                    fontSize: "medium"
                }
            }

            Image {
                id: divider2

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: header.bottom
                source: "../assets/dialer_top_number_bg.png"
            }


            Item {
                id: body

                anchors.top: divider2.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: footer.top

                Grid {
                    id: mainButtonsGrid
                    rows: 2
                    columns: 3
                    spacing: units.dp(6)

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: childrenRect.width
                    height: childrenRect.height

                    // TODO: fix assets for selected buttons
                    LiveCallKeypadButton {
                        iconSource: "../assets/incall_pause.png"
                        iconWidth: units.gu(3)
                        iconHeight: units.gu(3)
                        selected: liveCall.onHold
                        onClicked: {
                            if (call) {
                                call.held = !call.held
                            }
                        }
                    }

                    LiveCallKeypadButton {
                        iconSource: "../assets/incall_speaker.png"
                        selected: liveCall.isSpeaker
                        iconWidth: units.gu(3)
                        iconHeight: units.gu(3)
                        onClicked: {
                            if (call) {
                                call.speaker = !selected
                            }
                        }
                    }

                    LiveCallKeypadButton {
                        iconSource: "../assets/incall_mute.png"
                        iconWidth: units.gu(3)
                        iconHeight: units.gu(3)
                        selected: liveCall.isMuted
                        onClicked: {
                            if (call) {
                                call.muted = !call.muted
                            }
                        }
                    }

                    LiveCallKeypadButton {
                        iconSource: "../assets/incall_add.png"
                        iconWidth: units.gu(3)
                        iconHeight: units.gu(3)
                        selected: false
                        onClicked: {
                        }
                    }

                    LiveCallKeypadButton {
                        iconSource: "../assets/incall_keyboard.png"
                        iconWidth: units.gu(3)
                        iconHeight: units.gu(3)
                        selected: liveCall.isDtmf
                        onClicked: {
                            liveCall.isDtmf = true
                        }
                    }

                    LiveCallKeypadButton {
                        iconSource: "../assets/incall_contact.png"
                        iconWidth: units.gu(3)
                        iconHeight: units.gu(3)
                        selected: false
                        onClicked: {
                        }
                    }
                }
            }

            Item {
                id: footer
                height: childrenRect.height
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottomMargin: units.gu(4)

                Image {
                    id: divider3

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: hangupButton.top
                    anchors.bottomMargin: units.gu(2)
                    source: "../assets/horizontal_divider.png"
                    opacity: 0.4
                }

                CustomButton {
                    id: hangupButton

                    icon: "../assets/incall_hangup.png"
                    width: units.gu(19)
                    height: units.gu(8)
                    iconWidth: units.gu(5)
                    iconHeight: units.gu(5)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#bf400c"
                    ItemStyle.class: "dark-button"
                    onClicked: endCall()
                }
            }
        }

        back: FocusScope {
            anchors.fill: parent
            focus: true

            KeypadEntry {
                id: keypadEntry

                anchors.top: parent.top
                anchors.left: keypad.left
                anchors.right: keypad.right
                anchors.leftMargin: units.dp(-2)
                anchors.rightMargin: units.dp(-2)
                focus: true
            }

            Image {
                id: divider4

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: keypadEntry.bottom
                source: "../assets/dialer_top_number_bg.png"
            }


            Keypad {
                id: keypad

                anchors.top: divider4.bottom
                onKeyPressed: keypadEntry.value += label
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: units.dp(10)
            }

            CallButton {
                id: backButton
                objectName: "backButton"
                anchors.top: keypad.bottom
                anchors.topMargin: units.gu(2)
                color: "#bf400c"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: liveCall.isDtmf = false
            }
        }
    }
}
