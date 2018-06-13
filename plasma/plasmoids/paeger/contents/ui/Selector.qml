import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    id: selector

    width: label.implicitWidth + 12
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

    PlasmaComponents.Label {
      id: label
      text: active ? '\uf111' : '\uf10c'
      font.pixelSize: 8
      anchors {
        centerIn: parent
      }
    }
}
