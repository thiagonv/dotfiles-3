import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    id: selector

    width: height + 4
    height: root.height

    property bool current
    hoverEnabled: true

    property bool active

    onClicked: pagerModel.changePage(desktopId)

    onEntered: if (!active) cursorShape = Qt.PointingHandCursor
    onExited: cursorShape = Qt.ArrowCursor

    Rectangle {
      // anchors.fill: parent
      color: theme.highlightColor
      opacity: active ? 1 : 0
      height: 2
      width: parent.width
      y: parent.height - 2
    }

    PlasmaCore.IconItem {
      source: pagerItemGrid.icons[index]
      anchors {
        fill: parent
        margins: 5
      }
    }
}
