protocol
selectTarget
	self diagramController whenHoverChanged: [ :ctrl | self targetEntered: ctrl ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]