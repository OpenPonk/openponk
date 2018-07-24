views
applyView: aView
	aView view
		ifNotNil: [ :conf | 
			view canvas camera translateTo: (conf at: 'offset').
			view canvas camera scale: (conf at: 'zoom') ].
	aView layout ifNotNil: [ self layout: aView layout ]