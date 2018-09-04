rebuilding
rebuild
	controllers := nil.
	self cleanView.
	diagramView camera
		ifNotNil: [ :camera | 
			view canvas camera translateTo: camera offset.
			view canvas camera scale: camera zoom ].
	self showElements