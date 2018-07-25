views
applyView: aView
	aView camera
		ifNotNil: [ :camera | 
			view canvas camera translateTo: camera offset.
			view canvas camera scale: camera zoom ].
	aView layout ifNotNil: [ self layout: aView layout ].
	diagramView := aView