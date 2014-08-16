accessing
rebuild
	controllers := nil.
	self view cleanAll.
	model elements do: [ :modelElement | self addModelElement: modelElement ].
	self controllers
		do: [ :ctrl | 
			| element |
			element := ctrl view.
			(ctrl isKindOf: DCFsmVertexController)
				ifTrue: [ element @ RTDraggable ].
			self view add: element ].
	RTHorizontalTreeLayout on: self view elements.
	self view edges do: [ :edge | edge trachelShape pushBack ].
	self view signalUpdate