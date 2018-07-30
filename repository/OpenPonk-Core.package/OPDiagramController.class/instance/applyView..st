views
applyView: aView
	aView camera
		ifNotNil: [ :camera | 
			view canvas camera translateTo: camera offset.
			view canvas camera scale: camera zoom ].
	aView filters ifNotNil: [ :filters | filters do: [ :each | each applyOn: self ] ].
	self visibleElements: aView visibleElements.
	aView layout ifNotNil: [ self layout: aView layout ].
	diagramView := aView