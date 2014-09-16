/*
 * Copyright (C) 2012 Canonical, Ltd.
 *
 * Authors:
 *  Gustavo Pichorim Boiko <gustavo.boiko@canonical.com>
 *
 * This file is part of telephony-service.
 *
 * telephony-service is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * telephony-service is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "voicemailindicator.h"
#include "telepathyhelper.h"
#include "messagingmenu.h"
#include "accountentry.h"
#include <QDebug>
#include <QDBusReply>

VoiceMailIndicator::VoiceMailIndicator(QObject *parent)
: QObject(parent),
  mConnection(QDBusConnection::sessionBus())
{
    connect(TelepathyHelper::instance(), SIGNAL(accountReady()), SLOT(onAccountReady()));
    connect(TelepathyHelper::instance(), SIGNAL(connectedChanged()), SLOT(onAccountReady()));
}

void VoiceMailIndicator::onAccountReady()
{
    Q_FOREACH(AccountEntry *account, TelepathyHelper::instance()->accounts()) {
        connect(account, SIGNAL(voicemailIndicatorChanged()), this, SLOT(onVoicemailIndicatorChanged()));
        connect(account, SIGNAL(voicemailCountChanged()), this, SLOT(onVoicemailIndicatorChanged()));
        if (account->voicemailIndicator()) {
            MessagingMenu::instance()->showVoicemailEntry(account);
        } else {
            MessagingMenu::instance()->hideVoicemailEntry(account);
        }
    }
}

void VoiceMailIndicator::onVoicemailIndicatorChanged()
{
    AccountEntry *account = qobject_cast<AccountEntry*>(sender());
    if (!account) {
        return;
    }

    if (account->voicemailIndicator()) {
        MessagingMenu::instance()->showVoicemailEntry(account);
    } else {
        MessagingMenu::instance()->hideVoicemailEntry(account);
    }
}
