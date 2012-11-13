/*
 * Copyright 2012 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 0.1

// FIXME: one liners crop the arrow
Item {
    id: messageBubble

    property alias text: label.text
    property bool mirrored: false

    width: units.gu(34)
    height: bubble.height

    BorderImage {
        id: bubble

        anchors.left: parent.left
        anchors.right: parent.right

        property int topPadding: units.gu(2)
        property int bottomPadding: units.gu(2)
        property int leftPadding: messageBubble.mirrored ? units.gu(2) : units.gu(4)
        property int rightPadding: units.gu(2)
        height: label.height + topPadding + bottomPadding

        smooth: true
        source: messageBubble.mirrored ? "../assets/bubble_right.png" : "../assets/bubble_left.png"
        border {top: units.dp(17); bottom: units.dp(22); left: messageBubble.mirrored ? units.dp(15) : units.dp(24); right: messageBubble.mirrored ? units.dp(24) : units.dp(15)}
    }

    TextCustom {
        id: label

        anchors.left: bubble.left
        anchors.right: bubble.right
        anchors.leftMargin: bubble.leftPadding
        anchors.rightMargin: bubble.rightPadding

        anchors.top: bubble.top
        anchors.topMargin: bubble.topPadding

        lineHeight: 1.3
        wrapMode: Text.WordWrap
        fontSize: "small"
        color: Qt.rgba(0.4, 0.4, 0.4, 1.0)
        text: "Test text over multiple lines. Lorem Ipsum bla bla bla bla."
    }
}