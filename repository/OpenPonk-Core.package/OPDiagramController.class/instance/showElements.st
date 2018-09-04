rebuilding
showElements
	self showAllElements.
	diagramView filters ifNotNil: [ :filters | filters do: [ :each | each applyOn: self ] ].
	diagramView visibleElements ifNotEmpty: [ :elements | self visibleElements: elements ]