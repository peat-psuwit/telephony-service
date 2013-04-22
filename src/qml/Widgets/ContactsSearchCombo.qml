/*
 * Copyright 2012-2013 Canonical Ltd.
 *
 * This file is part of phone-app.
 *
 * phone-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * phone-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.PhoneApp 0.1
import "../Widgets" as LocalWidgets

LocalWidgets.DropDownSearch {
    id: search

    signal contactSelected(variant contact, string number)

    ContactProxyModel {
        id: contacts
        model: contactModel
        filterText: search.text != "" ? search.text : "some text that won't match"
    }

    model: contacts

    delegate: ContactsSearchDelegate {
        anchors.left: parent ? parent.left : undefined
        anchors.right: parent ? parent.right : undefined
        isLast: model  && contacts ? (index == (contacts.count - 1)) : false

        onContactClicked: {
            search.text = number
            search.state = "idle";
            search.contactSelected(contact, number);
        }
    }

    listMaximumHeight: units.gu(38)
}