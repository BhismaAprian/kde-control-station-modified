import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami 

Card {
    id: sliderComp
    signal moved
    signal actionButtonClicked

    property bool pressed: false
    property alias title: title.text
    property alias secondaryTitle: secondaryTitle.text
    property var value: 0
    property bool useIconButton: false
    property string source

    property bool canTogglePage: false

    property bool showTitle: true
    property bool thinSlider: false
    property bool mediumSizeSlider: false

    property int from: 0
    property int to: 100

    property color highlightColor: root.useSystemColorsOnSliders ? root.themeHighlightColor : root.slidersColor

    // Helps to play volume feedback while moving with cursor
    Binding { sliderComp.pressed: sliderLoader.item.pressed }

    // Binds slider value whent it's changed by keyboard
    Binding { 
        target: sliderLoader.item
        property: "value"
        value: sliderComp.value
        restoreMode: Binding.RestoreBindingOrValue
    }

    Connections {
        target: sliderLoader.item
        function onMoved() {
            sliderComp.value = sliderLoader.item.value;
            sliderComp.moved();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.largeSpacing
        clip: true
        spacing: 1

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 1
            visible: showTitle

            PlasmaComponents.Label {
                id: title
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                font.pixelSize: root.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
                elide: Text.ElideRight
                color: "#333333" // Dark text
            }

            PlasmaComponents.Label {
                id: secondaryTitle
                visible: root.showPercentage
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                font.pixelSize: root.largeFontSize
                font.weight: Font.Bold
                font.capitalization: Font.Capitalize
                horizontalAlignment: Text.AlignRight
                color: "#333333" // Dark text
            }


        }
        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0

            Kirigami.Icon {
                id: icon
                source: sliderComp.source
                visible: !sliderComp.useIconButton
                Layout.preferredHeight: root.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
                Layout.margins: 0
                color: "#333333" // Dark icon
            }
            
            PlasmaComponents.ToolButton {
                id: iconButton
                visible: sliderComp.useIconButton
                icon.name: sliderComp.source
                Layout.preferredHeight: root.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: sliderComp.actionButtonClicked()
            }

            Loader {
                id: sliderLoader
                sourceComponent: root.usePlasmaSliders ? plasmaSlider : customSlider
                Layout.fillWidth: true
                Layout.margins: 0

                onLoaded: { sliderLoader.item.value = sliderComp.value; }
            }

            Component {
                id: customSlider

                Slider {
                    id: slider
                    Layout.fillWidth: true
                    Layout.margins: 0
                    from: sliderComp.from
                    to: sliderComp.to
                    stepSize: 2
                    snapMode: Slider.SnapAlways

                    background: Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: thinSlider ? 7 : mediumSizeSlider ? 11 : 22
                        width: slider.availableWidth
                        height: parent.height
                        radius: height / 2
                        // Glassy track background
                        color: Qt.rgba(0, 0, 0, 0.1)
                        border.color: "transparent"

                        Rectangle {
                            id: levelIndicator
                            width: (value - from) / (to - from) * (slider.width - handle.width) + (handle.width)
                            height: parent.height
                            // MacOS Blue for active part
                            color: "#007AFF"
                            radius: height / 2
                            border.width: 0
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    handle: Rectangle {
                        id: handle
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: thinSlider ? 17 : 
                                        (mediumSizeSlider&&(slider.hovered || slider.pressed)) ? levelIndicator.height*3.7 : 
                                        levelIndicator.height
                        implicitHeight: thinSlider ? 17 : 
                                        (mediumSizeSlider&&(slider.hovered || slider.pressed)) ? levelIndicator.height*2.5 :
                                        levelIndicator.height
                        radius: mediumSizeSlider ? 10 : height / 2
                        // White handle with shadow/border
                        color: "#FFFFFF"
                        border.color: Qt.rgba(0, 0, 0, 0.1)
                        border.width: 1
                        
                        // Add shadow for handle
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 1
                            radius: 4
                            samples: 9
                            color: "rgba(0,0,0,0.2)"
                        }

                        Behavior on implicitWidth {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }

            }

            Component {
                id: plasmaSlider

                PlasmaComponents.Slider {
                    id: slider
                    Layout.fillWidth: true
                    Layout.margins: 0
                    from: sliderComp.from
                    to: sliderComp.to
                    stepSize: 2
                    snapMode: Slider.SnapAlways
                }
            }
            
            PlasmaComponents.ToolButton {
                id: openVolumePageButton
                visible: sliderComp.canTogglePage
                icon.name: "arrow-right"
                Layout.preferredHeight: root.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: sliderComp.clicked()
            }
        }
    }
}
