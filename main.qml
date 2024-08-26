import QtQuick 2.12
import QtQuick 2.15
import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.12
import QtLocation 5.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0
import QtQuick 2.5
import QtQuick.XmlListModel 2.0

Window {
    id: window
    maximumWidth: 400
    maximumHeight: 560
    minimumWidth: 400
    minimumHeight: 560
    visible: true

    function filterModel(prefix) {
        countryModel.clear();
        var data = countryData.getCountryData();
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            if (item.prefix.startsWith(prefix)) {
                countryModel.append({
                    "flag": item.flag,
                    "prefix": item.prefix,
                    "country": item.country
                });
            }
        }
    }
    Rectangle{
        anchors.fill:parent
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: "white" }
            //GradientStop { position: 0.5; color: "white" }
            GradientStop { position: 1.0; color: "lightblue" }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(list.visible==true){
                list.visible=false;
            }
        }
    }

    property int counter: 160
    property int countermessages: 0

    property bool listVisible: false

    property string selectedFlag: ""
    property string selectedPrefix: ""


    property color borderColor: "transparent" // Default border color


    signal itemClicked(string flag, string prefix)

    function handleItemClicked(flag, prefix) {
        selectedFlag = flag;
        selectedPrefix = prefix;
    }


    //settings for credit
    Settings {
        id: appSettings
        property int credit: 0
        category: "MyApp"
        fileName: "userSettings.ini"
    }

    //bubbles
    Image {
        anchors.bottom: parent.bottom
        source: "qrc:/resources/bgd_bubbles.png"
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#E6E8EA"
        border.width: 10
        radius: 10
    }
    Rectangle {
        x:20
        y:120
        color:"white"
        border.color:"lightgrey"
        border.width:1
        radius:10
        id: list
        width: 360
        height: 300
        visible: false
        z:1
        //modality: Window.Modality.ApplicationModal
        //title: "Popup"

        ListView {
            anchors.fill: parent
            anchors.margins:10
            Layout.preferredHeight: 300
            clip:true
            width:340
            //Layout.fillWidth: true
            //visible: listVisible
            model: ListModel {
                id: countryModel
                Component.onCompleted: reload()
                function reload(){
                    var data = countryData.getCountryData();
                    for (var i = 0; i < data.length; i++) {
                        var item = data[i];
                        countryModel.append({
                                                "flag": item.flag,
                                                "prefix": item.prefix,
                                                "country": item.country
                                            });
                    }
                }
            }
            delegate: numbers
            spacing: 5
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn

            }
        }

        Component {
            id: numbers
            Rectangle {
                width: 320
                height: 40
                color: "white"
                radius: 10
                border.color: "lightgrey"
                border.width: 1
                opacity:0.85
                // Flag
                Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 30
                    color: "transparent"
                    Image {
                        id: flagg
                        anchors.fill: parent
                        source: "qrc:/resources/countries/flags/" + model.flag + ".jpg"
                    }
                }
                // Number
                Text {
                    x: 50
                    y: 10
                    text: model.country
                    font.pixelSize: 15
                }
                TextInput {
                    id: number
                    text: "+" + model.prefix
                    x: 270
                    y: 10
                    font.pixelSize: 15
                    readOnly: true
                    color: "black"
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        numberinput.text = "+" + model.prefix;
                        itemClicked(model.flag, model.prefix);
                        list.visible = false;
                    }
                    onEntered: {
                        parent.color = "lightgrey";
                    }
                    onExited: {
                        parent.color = "white";
                    }
                }
            }
        }

    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        // credit + buy credit
        RowLayout {
            width: parent.width
            spacing: 10
            Text {
                anchors.left: parent.left
                text: "Credit: "
                Layout.fillWidth: true
                font.pixelSize: 15
                Text {
                    x: 50
                    anchors.left: pomm.right
                    id: credit
                    text: appSettings.credit.toString()
                    font.pixelSize: 15
                }
            }
            Text{
                //anchors.fill:parent
                anchors.right: parent.right

                text: "Buy credit"
                font.pixelSize: 15
                color: "blue"
                MouseArea{
                    anchors.fill:parent
                    anchors.right: parent.right
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        var currentCredit = Number(credit.text);
                        if (!isNaN(currentCredit)) {
                            appSettings.credit = currentCredit + 5;
                            credit.text = appSettings.credit.toString();;
                        }
                    }
                }
            }
        }
        //numbers only - for input
        RowLayout{
            id: rowinput
            width: parent.width
            spacing: 10
            Rectangle{
                id:numbersinput
                width:200
                height: 40
                color:"white"
                radius: 10
                opacity: 0.90
                border.color: "lightgray"
                border.width: 1

                //flag
                Rectangle{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 30
                    color:"transparent"
                    Image{
                        id:flaginput
                        anchors.fill: parent
                        source:"qrc:/resources/countries/flags/"+selectedFlag+".jpg"
                    }
                }
                //number
                TextField{
                    width: parent.width - 40
                    height: parent.height
                    id:numberinput
                    text:""+selectedPrefix
                    x:50
                    font.pixelSize: 15
                    placeholderText: "Enter phone number"
                    background: Rectangle {
                        color: "transparent"
                        border.color: "transparent"
                    }

                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onTextChanged: {
                        if(numberinput.text == ""){
                            list.visible = false
                        }
                        else{
                        list.visible = true
                        if (numberinput.text.length > 0 && !numberinput.text.startsWith("+")) {
                            numberinput.text = "+" + numberinput.text;
                        }
                        selectedPrefix = numberinput.text.startsWith("+") ? numberinput.text.substring(1) : numberinput.text;
                        filterModel(selectedPrefix)

                        var flag = countryData.getFlagForNumber(selectedPrefix);
                        flaginput.source = "qrc:/resources/countries/flags/" + flag + ".jpg";
                    }
                    }
                    onHoveredChanged: {
                        numbersinput.border.color = hovered ? "blue" : "lightgrey";
                    }


                }
            }
            //arrow
            Rectangle{
                width: 30
                height: 30
                color:"transparent"
                Layout.fillWidth: true
                Image{
                    y: 12
                    source: "qrc:/resources/combo_arrow.png"

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(list.visible==true){
                            list.visible = false
                        }
                        else{
                        list.visible = true
                       // listVisible = !listVisible
                    }
                    }
                }

            }
            //send button
            Button{
                anchors.right: parent.right
                background: Rectangle{
                    id: but
                    color:"lightblue"
                    border.color: "lightgrey"
                    radius:6
                }
                contentItem: Text {
                    text: qsTr("Send")
                    font.pixelSize: 15
                    //font.bold: true
                    color: "white"  // Text color
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                //font.pixelSize: 12
                text:"   Send   "
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        but.color = "blue";
                    }
                    onExited: {
                        but.color = "lightblue";
                    }
                    onClicked:{
                        numberinput.text=""
                        flaginput.source=""
                        message.text=""
                        credit.text = credit.text - 5
                        //countryModel.reload()
                        filterModel("")
                    }
                }
            }

        }
        Rectangle {
            Layout.preferredHeight: 5
            color: "transparent"
        }
        //ListView
        /*RowLayout{
            width: parent.width
            height: 80

        }
        Rectangle {
            Layout.preferredHeight: 10
            color: "transparent"
        }*/
        //textbox + number of characters
        RowLayout{
            width: parent.width
            height: 200
            Rectangle {
                id:textbox
                width: parent.width
                height: parent.height
                color: "white"
                opacity: 0.85
                border.color: "lightgrey"
                border.width: 1
                radius:5
                Layout.fillWidth: true
                TextArea {
                    //width: parent.width
                    // height: parent.height
                    anchors.fill: parent
                    anchors.margins: 1
                    id: message
                    placeholderText: "Type message..."
                    text: ""
                    font.pixelSize: 15
                    wrapMode: TextArea.Wrap // Ensures text wraps within the area


                    /*onTextChanged: {
                        var totalCharacters = message.text.length;
                        countermessages = Math.ceil(totalCharacters / 160);
                        counter = totalCharacters % 160;
                        if (counter == 0 && totalCharacters > 0) {
                            counter = 160;
                        }
                    }*/
                    onTextChanged: {
                        var totalCharacters = message.text.length;
                        countermessages = Math.floor(totalCharacters / 160)+1;
                        var charsInCurrentMessage = totalCharacters % 160;
                        if (charsInCurrentMessage === 0 && totalCharacters > 0) {
                            counter = 160;
                        } else {
                            counter = 160 - charsInCurrentMessage;
                        }
                    }
                    onHoveredChanged: {
                        textbox.border.color = hovered ? "blue" : "lightgrey";
                    }

                }
            }
        }
        RowLayout{
            width: parent.width
            height: 40
            Rectangle{
                width: parent.width
                height:parent.height
                color:"transparent"
                Layout.fillWidth: true
                TextArea{
                    anchors.right: parent.right
                    id: characterCount
                    text: counter + "/" + countermessages
                    font.pixelSize: 15
                }
            }
        }
        //call + see rates
        RowLayout {
            width: parent.width
            spacing: 10
            Rectangle{
                width: 25
                height: 25
                color:"transparent"
                Image{
                    anchors.fill: parent
                    source: "qrc:/resources/handset.png"
                }
            }
            Text {
                text: "Call"
                Layout.fillWidth: true
                font.pixelSize: 15
            }
            Text {
                anchors {right:parent.right}
                text:"See rates"
                font.pixelSize: 15
            }
        }
    }
    onItemClicked: handleItemClicked(flag, prefix)

}
