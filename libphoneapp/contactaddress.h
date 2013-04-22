/*
 * Copyright (C) 2012 Canonical, Ltd.
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

#ifndef CONTACTADDRESS_H
#define CONTACTADDRESS_H

#include "contactdetail.h"
#include <QContactAddress>

class ContactAddress : public ContactDetail
{
    Q_OBJECT
    Q_PROPERTY(QString country READ country WRITE setCountry NOTIFY countryChanged)
    Q_PROPERTY(QString locality READ locality WRITE setLocality NOTIFY localityChanged)
    Q_PROPERTY(QString postOfficeBox READ postOfficeBox WRITE setPostOfficeBox NOTIFY postOfficeBoxChanged)
    Q_PROPERTY(QString postcode READ postcode WRITE setPostcode NOTIFY postcodeChanged)
    Q_PROPERTY(QString region READ region WRITE setRegion NOTIFY regionChanged)
    Q_PROPERTY(QString street READ street WRITE setStreet NOTIFY streetChanged)
    Q_PROPERTY(QVariant subTypes READ subTypes WRITE setSubTypes NOTIFY subTypesChanged)

public:
    explicit ContactAddress(const QContactDetail &detail = QContactAddress(), QObject *parent = 0);

    QString country() const;
    void setCountry(const QString &value);

    QString locality() const;
    void setLocality(const QString &value);

    QString postOfficeBox() const;
    void setPostOfficeBox(const QString &value);

    QString postcode() const;
    void setPostcode(const QString &value);

    QString region() const;
    void setRegion(const QString &value);

    QString street() const;
    void setStreet(const QString &value);

    QVariant subTypes() const;
    void setSubTypes(const QVariant &value);

Q_SIGNALS:
    void changed();
    void countryChanged();
    void localityChanged();
    void postOfficeBoxChanged();
    void postcodeChanged();
    void regionChanged();
    void streetChanged();
    void subTypesChanged();

};

#endif // CONTACTADDRESS_H