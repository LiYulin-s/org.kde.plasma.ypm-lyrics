import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {
        property int current_id: 0
        property string lyric: ""
        property bool trans: false
        Layout.preferredWidth: lyric_label.implicitWidth
        Layout.preferredHeight: lyric_label.implicitHeight
        //Layout.
        Label {
            id: lyric_label
            text: parent.lyric
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.textColor
        }

        Timer {
            interval: 100
            onTriggered: {
                update()
            }
            repeat: true
            running: true
            triggeredOnStart: true
        }
        function update() {
            let xhr = new XMLHttpRequest()
            xhr.open("GET", "http://localhost:5000/currentLyric/" + current_id)
            xhr.send()
            xhr.onreadystatechange = function () {
              if (xhr.readyState === 4 )  {
                if (xhr.status === 200) {
                    //console.log("response:" + xhr.responseText)
                    let res = JSON.parse(xhr.responseText)
                    if (res.status === 404) {
                        lyric = ""
                        return
                    }
                    current_id = "1"
                    trans = res.trans
                    if (trans === true) {
                        lyric = res.lyric + ' ' + res.tlyric
                    } else {
                        lyric = res.lyric
                    }
                  }
                }
               //console.log(lyric_label.implicitWidth)
            }
        }
    }
}
