hooks
renderIn: aView
	super renderIn: aView.
	view := aView.
	self update.
	elements
		do: [ :e | 
			| cb |
			cb := TRTranslationCallback block: [ :shape :step | e translateBy: step ].
			callbacks add: cb.
			background trachelShape addCallback: cb ].
	draggableBackground
		ifTrue: [ background @ RTDraggable ].
	aView add: background.
	elements do: [ :e | aView add: e ]