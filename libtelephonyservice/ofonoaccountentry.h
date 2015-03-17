/*
 * Copyright (C) 2013-2015 Canonical, Ltd.
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

#ifndef OFONOACCOUNTENTRY_H
#define OFONOACCOUNTENTRY_H

#include "accountentry.h"

class OfonoAccountEntry : public AccountEntry
{
    Q_OBJECT
    Q_PROPERTY(QStringList emergencyNumbers READ emergencyNumbers NOTIFY emergencyNumbersChanged)
    Q_PROPERTY(QString voicemailNumber READ voicemailNumber NOTIFY voicemailNumberChanged)
    Q_PROPERTY(uint voicemailCount READ voicemailCount NOTIFY voicemailCountChanged)
    Q_PROPERTY(bool voicemailIndicator READ voicemailIndicator NOTIFY voicemailIndicatorChanged)
    Q_PROPERTY(QString networkName READ networkName NOTIFY networkNameChanged)
    Q_PROPERTY(bool emergencyCallsAvailable READ emergencyCallsAvailable NOTIFY emergencyCallsAvailableChanged)
    Q_PROPERTY(bool simLocked READ simLocked NOTIFY simLockedChanged)
    Q_PROPERTY(QString serial READ serial NOTIFY serialChanged)
    friend class AccountEntryFactory;

public:
    QStringList emergencyNumbers() const;
    QString voicemailNumber() const;
    uint voicemailCount() const;
    bool voicemailIndicator() const;
    QString networkName() const;
    bool emergencyCallsAvailable() const;
    bool simLocked() const;
    QString serial() const;

    // reimplemented from AccountEntry
    virtual AccountEntry::AccountType type() const;
    virtual bool connected() const;
    virtual bool compareIds(const QString &first, const QString &second) const;
    virtual QStringList addressableVCardFields();

Q_SIGNALS:
    void emergencyNumbersChanged();
    void voicemailNumberChanged();
    void voicemailCountChanged();
    void voicemailIndicatorChanged();
    void networkNameChanged();
    void emergencyCallsAvailableChanged();
    void simLockedChanged();
    void serialChanged();

private Q_SLOTS:
    void onEmergencyNumbersChanged(const QStringList &numbers);
    void onVoicemailNumberChanged(const QString &number);
    void onVoicemailCountChanged(uint count);
    void onVoicemailIndicatorChanged(bool visible);

    // reimplemented from AccountEntry
    void onConnectionChanged();

protected:
    explicit OfonoAccountEntry(const Tp::AccountPtr &account, QObject *parent = 0);

private:
    QStringList mEmergencyNumbers;
    QString mVoicemailNumber;
    uint mVoicemailCount;
    bool mVoicemailIndicator;
    QString mSerial;
};

#endif // OFONOACCOUNTENTRY_H
