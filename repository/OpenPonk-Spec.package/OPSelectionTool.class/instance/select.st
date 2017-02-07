protocol
select
	selectedController := OPPaletteNullController new.
	self diagramController whenHoverChanged: [ :ctrl |  ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]