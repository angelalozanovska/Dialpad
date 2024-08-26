#include "CountryData.h"
#include <QFile>
#include <QTextStream>
#include <QStringList>

CountryData::CountryData(QObject *parent) : QObject(parent)
{
    loadData();
}

void CountryData::loadData()
{
    QFile file(":/resources/countries/countries.txt");
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            QStringList parts = line.split(",", QString::SkipEmptyParts); // flag,prefix,country

            if (parts.size() >= 3) {
                QString flag = parts[0].trimmed();
                QString prefix = parts[1].trimmed();
                QString country = parts[2].trimmed();

                m_countryData.append({flag, prefix, country});
            }
        }
        file.close();
    }
}

QString CountryData::getFlagForPrefix(const QString &prefix)
{
    for (const auto &entry : m_countryData) {
        if (entry[1] == prefix) {
            return entry[0];
        }
    }
    return QString();
}

QString CountryData::getFlagForNumber(const QString &number)
{
    for (const auto &entry : m_countryData) {
        if (number.startsWith(entry[1])) {
            return entry[0];
        }
    }
    return QString();
}


QString CountryData::getPrefixForFlag(const QString &flag)
{
    for (const auto &entry : m_countryData) {
        if (entry[0] == flag) {
            return entry[1];
        }
    }
    return QString();
}

QStringList CountryData::getAllFlags()
{
    QStringList flags;
    for (const auto &entry : m_countryData) {
        flags.append(entry[0]);
    }
    return flags;
}

QStringList CountryData::getAllPrefixes()
{
    QStringList prefixes;
    for (const auto &entry : m_countryData) {
        prefixes.append(entry[1]);
    }
    return prefixes;
}

QStringList CountryData::getAllCountries()
{
    QStringList countries;
    for (const auto &entry : m_countryData) {
        countries.append(entry[2]);
    }
    return countries;
}



QVariantList CountryData::getCountryData() const
{
    QVariantList list;
    for (const auto &entry : m_countryData) {
        QVariantMap map;
        map["flag"] = entry[0];
        map["prefix"] = entry[1];
        map["country"] = entry[2];
        list.append(map);
    }
    return list;
}
