as yet unclassified
constraintForStartEnd: anElement
	| moveBlock b callback |
	moveBlock := [ 
	anElement
		translateTo:
			((edge shape attachPoint startingPointOf: edge)
				+ (edge shape attachPoint endingPointOf: edge)) / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback