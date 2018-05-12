import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0    as PlasmaComponents
import org.kde.plasma.core 2.0          as PlasmaCore

Item
{
    id: root

    Layout.preferredWidth: date_label.implicitWidth + 18   // 2 px of separation
    Layout.maximumWidth: Layout.preferredWidth
    // Layout.preferredHeight: date_label.height + 4
    // Layout.maximumHeight:   date_label.height + 4
    Layout.fillHeight: true

    PlasmaCore.DataSource {
      id: time_src
      engine: "time"
      connectedSources: ["Local"]
      interval: 1000
    }

    Text {
        id:  date_label
        text: Qt.formatDateTime( time_src.data.Local.DateTime, "dddd, MMM dd · hh:mm" )
        anchors {
          left: parent.left
          leftMargin: 6
          verticalCenter: parent.verticalCenter
        }
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: theme.textColor
        font: theme.defaultFont

        PlasmaCore.ToolTipArea {
          mainText: Qt.formatDateTime( time_src.data.Local.DateTime, "dddd, dd/MM/yyyy" )
          anchors.fill: parent
        }
    }
}
