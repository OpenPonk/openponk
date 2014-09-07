as yet unclassified
renderIn: aView
	super renderIn: aView.
	view := aView.
	background @ RTDraggable.
	aView add: background.
	groups
		do: [ :g | 
			| cb |
			g disableDragging.
			g renderIn: view.
			cb := TRTranslationCallback block: [ :shape :step | g background translateBy: step ].
			background trachelShape addCallback: cb ].
	self update