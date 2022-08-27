
/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/
import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.fullRepresentation: Item {
        property int current_id: 0
        property string lyric: "null"
        property bool trans: false
        Layout.preferredWidth: lyric_label.implicitWidth
        Layout.preferredHeight: lyric_label.implicitHeight
        //Layout.
        Label {
            id: lyric_label
            text: parent.lyric
            //horizontalAlignment: horizontalCenter
            //verticalAlignment: verticalCenter
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter //垂直居中，控件必须有height才可以使用
            horizontalAlignment: Text.AlignHCenter //水平居中，控件必须有width才可以使用
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
            xhr.open("GET", "http://127.0.0.1:5000/currentLyric/" + current_id)
            xhr.send()
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 || xhr.status === 200) {

                    //console.log("response:" + xhr.responseText)

                    let res = JSON.parse(xhr.responseText)
                    if (res.status === 404) {
                        lyric = ""
                        return
                    }
                    current_id = res.id

                    trans = res.trans
                    if (trans === true) {
                        lyric = res.lyric + ' ' + res.tlyric
                    } else {
                        lyric = res.lyric
                    }
                }
               // console.log(lyric_label.implicitWidth)
            }
        }
    }
}
