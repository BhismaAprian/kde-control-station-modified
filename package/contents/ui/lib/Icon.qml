import QtQuick 2.15
import QtQuick.Layouts 1.15
//import QtGraphicalEffects 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects


Item
{
    property color sourceColor
    property alias source: icon.source
    property alias selected: icon.selected
    property bool fullSizeIcon : false
    property bool customIcon: false
    property bool enableQuickAction: false

    signal quickActionTriggered

    property color highlightColor: root.useSystemColorsOnToggles ? root.themeHighlightColor : root.toggleButtonsColor
    property color iconColor: root.useSystemColorsOnToggles ?  Kirigami.Theme.highlightedTextColor : root.toggleButtonsIconColor

    Rectangle {
        id: rect
        radius: width/2
        // Active state blue, otherwise transparent/grey
        color: icon.selected ? "#007AFF" : (sourceColor.valid ? sourceColor : "transparent")
        anchors.fill: parent
        
        // Add border for inactive state to match glass style
        border.color: icon.selected ? "transparent" : "rgba(0,0,0,0.1)"
        border.width: icon.selected ? 0 : 1

        Kirigami.Icon {
            id: icon
            visible: true
            anchors.fill: parent
            anchors.margins: fullSizeIcon ? root.largeSpacing : root.smallSpacing
            anchors.centerIn: parent
            selected: false
            isMask: customIcon
            // White icon when selected (blue bg), dark icon otherwise
            color: selected ? "white" : "#333333"
        }
    }

    MouseArea {
        enabled: !root.editingLayout && enableQuickAction
        hoverEnabled: true
        anchors.fill: parent
        
        onClicked: quickActionTriggered()
    }
}
