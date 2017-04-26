// Copyright (C) 2017 Allegorithmic
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import AlgWidgets 1.0
import AlgWidgets.Style 1.0
import "."

AlgWindow
{
	id: window
	title: "Substance Painter - Resources Updater"
	visible: false
	width: Style.window.width
	height: Style.window.height
	minimumWidth: Style.window.minimumWidth
	minimumHeight: Style.window.minimumHeight
	
	//Flags to keep the window on top
	flags: Qt.Window
		| Qt.WindowTitleHint // title
		| Qt.WindowSystemMenuHint // Recquired to add buttons
		| Qt.WindowMinMaxButtonsHint // minimize and maximize button
		| Qt.WindowCloseButtonHint // close button
		| Qt.WindowStaysOnTopHint;


	ColumnLayout
	{
		id: horizontalLayout
		anchors.fill: parent

		Rectangle
		{
			id: titleBar
			Layout.preferredWidth: parent.width
			height: Style.widgets.barHeight

			color: AlgStyle.background.color.darkGray //#252525

			RowLayout
			{
				width: parent.width
				anchors {
					verticalCenter: parent.verticalCenter;
				}
				
				AlgLabel
				{
					id: projectName
					font.pixelSize: 14
					font.bold: true
					Layout.leftMargin: Style.margin
					
					text: "Project : "
				}

				AlgCheckBox
				{
					checked: true
					text: "Keep window on top"
					Layout.alignment: Qt.AlignRight

					onClicked:
					{
						if( checked ) {
							// Add the flag "keep window on top"
							window.flags |= Qt.WindowStaysOnTopHint;
						} else {
							// Remove the flag "keep window on top"
							window.flags &= ~Qt.WindowStaysOnTopHint;
						}
					}
				}
			}
		}
		
		
		Rectangle
		{
			id: filteringBar
			Layout.preferredWidth: parent.width
			height: Style.widgets.barHeight
			
			color: AlgStyle.background.color.normal //#323232
			
			RowLayout
			{
				width: parent.width
				anchors {
					verticalCenter: parent.verticalCenter;
				}
				
				AlgLabel
				{
					Layout.leftMargin: Style.margin
					text: "Status : "
				}
				
				AlgComboBox
				{
					id: statusFilter
					Layout.preferredWidth: Style.widgets.buttonWidth

					model: ["All", "Outdated", "Non-Outdated"]

					onCurrentIndexChanged:
					{
						refreshInterface()
					}
				}
				
				
				AlgLabel
				{
					Layout.leftMargin: Style.margin
					text: "Name filter : "
				}
				
				AlgTextInput
				{
					id: textFilter
					Layout.preferredWidth: Style.widgets.buttonWidth
					text: ""

					onTextChanged:
					{
						resourcesListView.filter_text = text
						refreshInterface()
					}
				}
				
				AlgToolButton
				{
					iconName: AlgStyle.icons.datawidget.remove
					visible: textFilter.text !== ""
					
					onClicked:
					{
						textFilter.text = ""
					}
				}
				
				Item
				{
					Layout.fillWidth: true
				}
				
				AlgButton
				{
					text: "Top"
					Layout.preferredWidth: Style.widgets.buttonWidth/2
					
					onClicked:
					{
						resourcesListView.scrollResourcesListToTop()
					}
				}
				
				AlgButton
				{
					text: "Bottom"
					Layout.preferredWidth: Style.widgets.buttonWidth/2
					Layout.rightMargin: Style.margin
					
					onClicked:
					{
						resourcesListView.scrollResourcesListToBottom()
					}
				}
			}
		}

		ResourcesListView
		{
			id: resourcesListView
		}
		
		Rectangle
		{
			Layout.preferredWidth: parent.width
			height: Style.widgets.barHeight
			
			color: AlgStyle.background.color.normal //#323232
			
			RowLayout
			{
				width: parent.width
				anchors {
					verticalCenter: parent.verticalCenter;
				}
				
				AlgButton
				{
					Layout.leftMargin: Style.margin
					text: "Refresh"
					
					onClicked:
					{
						refreshInterface()
					}
				}
				
				AlgLabel
				{
					id: infoResourcesCount
					Layout.fillWidth: true

					text: "(0 resources, 0 outdated)"
					opacity: 0.75
				}
				
				AlgButton
				{
					text: "Update All"
					Layout.rightMargin: Style.margin
					
					onClicked:
					{
						resourcesListView.updateAllResources()
					}
				}
			}
		}
	}
	
	function getFilterMode() {
		switch(statusFilter.currentIndex) {
		case 0: 
			return resourcesListView.filter_ALL
		case 1: 
			return resourcesListView.filter_OUTDATED
		case 2: 
			return resourcesListView.filter_NO_OUTDATED
		}
	}
	
	function refreshInterface() {
		try {
			projectName.text = "Project : "
			
			resourcesListView.current_filter = getFilterMode()
			resourcesListView.updateResourcesList()
			resourcesListView.scrollResourcesListToTop()

		} catch(err) {
			alg.log.exception(err)
		}
	}
}
