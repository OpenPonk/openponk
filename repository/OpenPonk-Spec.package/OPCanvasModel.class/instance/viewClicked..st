selection handling
viewClicked: anEvent
	self lastClickPosition: anEvent position.
	self diagramController selectView