views
applyView: aView
	aView camera
		ifNotNil: [ :camera | 
			view canvas camera translateTo: camera offset.
			view canvas camera scale: camera zoom ].
	aView filters ifNotNil: [ :filters | filters do: [ :each | each applyOn: self ] ].
	aView isDefault & aView visibleElements isEmpty
		ifTrue: [ self showAllElements ]
		ifFalse: [ self visibleElements: aView visibleElements ].
	aView layout ifNil: [ self applyDefaultLayout ] ifNotNil: [ self layout: aView layout ].
	diagramView := aView