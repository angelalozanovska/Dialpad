import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Test QML File"

    Component.onCompleted: {

        readFile();
    }

    function readFile() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "qrc:/resources/countries/countries.txt");

        xhr.onreadystatechange = function() {
                var responseText = xhr.responseText;
                var lines = responseText.split('\n');
                if (lines.length > 0) {
                    console.log("First row:", lines[0]);
                } else {
                    console.log("The file is empty.");
                }
        };

        xhr.onerror = function() {
            console.error("Error occurred during XMLHttpRequest.");
        };

        xhr.send();
    }
}

