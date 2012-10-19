# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2012 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.


class MessagesPanel(object):
    """An emulator class that makes it easy to interact with the messages
    panel.

    """
    def __init__(self, app):
        self.app = app

    def get_messages_searchbox(self):
        """Returns the main searchbox attached to the messages panel."""
        return self.app.select_single("TextField", placeholderText="Search messages")

    def get_new_message_list_item(self):
        """Returns 'New Message' list item."""
        return self.app.select_single("LabelVisual", text='New Message')

    def get_messages_view(self):
        """Returns the MessagesView."""
        return self.app.select_single("MessagesView")

    def get_new_message_send_to_box(self):
        """Return the "To" input box for sending an sms."""
        return self.app.select_single("NewMessageHeader")

    def get_message_send_button(self):
        """Returns the send button."""
        return self.app.select_single("Button", text='Send')

    def get_new_message_text_box(self):
        """Returns main message box for sending an sms."""
        return self.app.select_many("SearchEntry")[1]
