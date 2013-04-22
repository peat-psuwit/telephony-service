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

QtObject {
    property url source
    property int tab
    property bool loaded: mainView.view != undefined && mainView.view.source == source

    function load(properties, clear) {
        if (properties == undefined) {
            properties = {};
        }
        properties["source"] = source;
        properties["previousTab"] = mainView.selectedTabIndex;
        mainView.selectedTabIndex = tab
        if (clear) {
            mainView.resetView();
        }

        mainView.viewStack.push(Qt.resolvedUrl(source), properties);
    }
}