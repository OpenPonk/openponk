protocol
selectSource
	self diagramController whenHoverChanged: [ :ctrl | self sourceEntered: ctrl ].
	self diagramController whenSelectionChanged: [ :ctrl | self sourceSelected: ctrl ]