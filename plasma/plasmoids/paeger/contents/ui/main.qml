import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents
import org.kde.draganddrop 2.0
import org.kde.plasma.private.pager 2.0
import "utils.js" as Utils

MouseArea {
    id: root

    property bool isActivityPager: (plasmoid.pluginName == "org.kde.plasma.activitypager")
    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    property var activityDataSource: null

    Layout.minimumWidth: pagerItemGrid.width
    Layout.minimumHeight: pagerItemGrid.height

    Layout.maximumWidth: Layout.preferredWidth
    Layout.maximumHeight: Layout.preferredWidth

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.status: pagerModel.shouldShowPager ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.HiddenStatus

    property bool dragging: false
    property int dragId

    property int dragSwitchDesktopId: -1

    anchors.fill: parent
    acceptedButtons: Qt.NoButton

    function action_addDesktop() {
        pagerModel.addDesktop();
    }

    function action_removeDesktop() {
        pagerModel.removeDesktop();
    }

    function action_openKCM() {
        KQuickControlsAddonsComponents.KCMShell.open("desktop");
    }

    function action_showActivityManager() {
        if (!activityDataSource) {
            activityDataSource = Qt.createQmlObject('import org.kde.plasma.core 2.0 as PlasmaCore; \
                PlasmaCore.DataSource { id: dataSource; engine: "org.kde.activities"; \
                connectedSources: ["Status"] }', root);
        }

        var service = activityDataSource.serviceForSource("Status")
        var operation = service.operationDescription("toggleActivityManager")
        service.startOperationCall(operation)
    }

    onWheel: {
        if (wheel.angleDelta.y > 0 || wheel.angleDelta.x > 0) {
            pagerModel.changePage((repeater.count + pagerModel.currentPage - 2) % repeater.count);
        } else {
            pagerModel.changePage(pagerModel.currentPage % repeater.count);
        }
    }

    PagerModel {
        id: pagerModel

        enabled: root.visible

        showDesktop: (plasmoid.configuration.currentDesktopSelected == 1)

        showOnlyCurrentScreen: plasmoid.configuration.showOnlyCurrentScreen
        screenGeometry: plasmoid.screenGeometry

        pagerType: PagerModel.VirtualDesktops
    }

    Connections {
        target: plasmoid.configuration

        onShowWindowIconsChanged: {
            // Causes the model to reset; Component.onCompleted in the
            // window delegate now gets a chance to create the icon item,
            // which it otherwise will not do.
            pagerModel.refresh();
        }

        onDisplayedTextChanged: {
            // Causes the model to reset; Component.onCompleted in the
            // desktop delegate now gets a chance to create the label item,
            // which it otherwise will not do.
            pagerModel.refresh();
        }
    }

    Row {
        id: pagerItemGrid

        property var icons: ['\uf1a0', '\uf126', '\uf1bc', '\uf120']
        property var labels: ['Web', 'Code', 'Media', 'Terminal']

        Repeater {
            id: repeater
            model: pagerModel

            Selector {
                id: desktop

                property int desktopId: index
                active: (index == pagerModel.currentPage)
            }
        }
    }

    Component.onCompleted: {
        if (KQuickControlsAddonsComponents.KCMShell.authorize("desktop.desktop").length > 0) {
            plasmoid.setAction("addDesktop", i18n("Add Virtual Desktop"), "list-add");
            plasmoid.setAction("removeDesktop", i18n("Remove Virtual Desktop"), "list-remove");
            plasmoid.action("removeDesktop").enabled = Qt.binding(function() {
                return repeater.count > 1;
            });

            plasmoid.setAction("openKCM", i18n("Configure Desktops..."), "configure");
        }
    }
}
