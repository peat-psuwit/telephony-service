import QtQuick 1.1
import QtMobility.contacts 1.1
import "../Widgets"
import "../ContactUtils"

DropDownSearch {
    id: search

    signal contactSelected(variant contact, string number)

    model: ContactModel {
        manager: "folks"
        filter: ContactFilters {
            filterText: search.searchQuery
        }
    }
    delegate: ContactsSearchDelegate {
        anchors.left: parent ? parent.left : undefined
        anchors.right: parent ? parent.right : undefined

        onContactClicked: {
            search.text = number
            search.state = "idle";
            search.contactSelected(contact, number);
        }
    }

    listMaximumHeight: 300
}