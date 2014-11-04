actions
select
	selectedController := nil.
	self diagramController whenHoverChanged: [ :ctrl |  ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]