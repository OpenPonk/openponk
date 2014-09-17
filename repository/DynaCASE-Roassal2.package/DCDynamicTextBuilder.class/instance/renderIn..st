hooks
renderIn: aView
	| cbRemove |
	super renderIn: aView.
	view := aView.
	self update.
	elements
		do: [ :e | 
			| cb |
			cb := TRTranslationCallback block: [ :shape :step | e translateBy: step ].
			callbacks add: cb.
			background trachelShape addCallback: cb.
			cb := TRRemoveCallback new block: [ :shape | e remove ] ].
	cbRemove := TRRemoveCallback new block: [ :shape | elements do: [ :e | e remove ] ].
	background trachelShape addCallback: cbRemove.
	draggableBackground
		ifTrue: [ background @ RTDraggable ].
	aView add: background.
	elements do: [ :e | aView add: e ]