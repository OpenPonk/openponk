actions
select
	self diagramController whenHoverChanged: [ :ctrl |  ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]