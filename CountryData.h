#ifndef COUNTRYDATA_H
#define COUNTRYDATA_H

#endif // COUNTRYDATA_H
#include <QObject>
#include <QVector>
#include <QString>
#include <QPair>
#include <QVariant>


class CountryData : public QObject
{
    Q_OBJECT
public:
    explicit CountryData(QObject *parent = nullptr);
    Q_INVOKABLE QString getFlagForPrefix(const QString &prefix); //najdi zname za daden prefiks
    Q_INVOKABLE QString getPrefixForFlag(const QString &flag); //najdi prefiks za izbrano zname
    Q_INVOKABLE QStringList getAllFlags();
    Q_INVOKABLE QStringList getAllPrefixes();
    Q_INVOKABLE QString getFlagForNumber(const QString &number); //najdi zname za daden broj
    Q_INVOKABLE QVariantList getCountryData() const; //lista od zname i prefiks
    Q_INVOKABLE QStringList getAllCountries();


private:
    QVector<QVector<QString>> m_countryData; // Triple of (flag, prefix, country)
    void loadData(); // Load data from the local file
};


