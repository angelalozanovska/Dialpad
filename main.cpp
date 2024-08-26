#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <iostream>
#include "CountryData.h"

/*QVector<QString> Flags;
QVector<QString> Prefixes;

void readFile() {
    QFile file(":/resources/countries/countries.txt");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        std::cout << "Could not open file" << std::endl;
        return;
    }

    QTextStream in(&file);

    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = line.split(',', QString::SkipEmptyParts);
        QVector<QString> Array;


        for (const QString &field : fields) {
            Array.append(field.trimmed()); //site chisti vo edna lista
        }
        for (int i = 0; i < Array.size(); i++) {
            if (i + 1 < Array.size()) {
                Flags.append(Array[i]); //prva kolona - koe zname
                Prefixes.append(Array[i + 1]); //vtora kolona - koj prefiks
            }
            i=i+2;
        }

        for (int i = 0; i < Flags.size(); i++){
            std::cout<<"Flag: "<<Flags[i].toStdString()<<" and its prefix: "<<Prefixes[i].toStdString()<<std::endl;
        }
    }
    file.close();
}*/



int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    CountryData countryData;
    engine.rootContext()->setContextProperty("countryData", &countryData);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();

}



