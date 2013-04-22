/*
 * Copyright (C) 2012-2013 Canonical, Ltd.
 *
 * Authors:
 *  Gustavo Pichorim Boiko <gustavo.boiko@canonical.com>
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

#ifndef CONVERSATIONFEEDMODEL_H
#define CONVERSATIONFEEDMODEL_H

#include <QAbstractListModel>
#include "conversationfeeditem.h"

class ContactEntry;

class ConversationFeedModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ConversationFeedModel(QObject *parent = 0);
    virtual ~ConversationFeedModel();

    enum FeedRoles {
        ContactId = Qt::UserRole,
        ContactAlias,
        ContactAvatar,
        Timestamp,
        Date,
        Incoming,
        NewItem,
        ItemType,
        FeedItem,
        GroupingProperty,
        CustomRole
    };

    /**
     * Reports if a given index matches the search term
     * @param searchTerm The search term
     * @param index A valid index of the model.
     * @return true if the item matches the search term
     */
    virtual bool matchesSearch(const QString &searchTerm, const QModelIndex &index) const;

    /**
     * Returns a string identifying the type of a given item
     * @param index A valid index
     * @return The item type
     */
    virtual QString itemType(const QModelIndex &index) const;

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    QModelIndex indexFromEntry(ConversationFeedItem *entry) const;
    ConversationFeedItem *entryFromIndex(const QModelIndex &index) const;
    void addItem(ConversationFeedItem *item);
    void removeItem(ConversationFeedItem *item);
    void clear();

    void fillContactInfo(ConversationFeedItem *entry, ContactEntry *contact);
    void clearContactInfo(ConversationFeedItem *entry);
    bool checkNonStandardNumbers(ConversationFeedItem *item);

protected:
    void updateLogForContact(ContactEntry *contactEntry);
    virtual bool contactMatchesItem(ContactEntry *contact, ConversationFeedItem *item) const;

private Q_SLOTS:
    void onItemChanged();

    // ContactModel related slots
    void onContactAdded(ContactEntry *contact);
    void onContactChanged(ContactEntry *contact);
    void onContactRemoved(const QString &contactId);


protected:
    QList<ConversationFeedItem*> mItems;
};

#endif // CONVERSATIONFEEDMODEL_H