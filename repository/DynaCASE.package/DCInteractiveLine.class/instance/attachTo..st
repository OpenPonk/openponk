as yet unclassified
attachTo: anElement

	target = anElement ifFalse:	[
		self running ifTrue: [ self cancel ].
		target := anElement.
		diagramController view when: TRMouseMove do: [ :evt | self attachToMouse: source position. diagramController updateView.].
		diagramController controllers do: [ :ctrl | ctrl view when: TRMouseMove do: [ :evt | ctrl attachInteractiveLine: self ]].
		line := lineType edgeFrom: ((diagramController findControllerByView: source) view) to: target.
		line shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
		diagramController view add: line.
		diagramController updateView.	
		running := true.
	]