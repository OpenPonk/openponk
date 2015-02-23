protocol
select
	selectedController := DCPaletteNullController new.
	self diagramController whenHoverChanged: [ :ctrl |  ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]