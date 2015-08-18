rendering
renderIn: aView
	element := self shape element.
	aView add: element.
	initialPosition ifNotNil: [ element translateTo: initialPosition ].
	element addConnectedEdge: edge.
	element @ self draggableClass.
	element addCallback: (TRTranslationCallback block: [ :aShape :step | self propagate: step from: self ])