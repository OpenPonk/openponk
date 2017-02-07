as yet unclassified
constraintForStart: anElement
	| moveBlock b callback |
	moveBlock := [ anElement translateTo: ((edge shape attachPoint startingPointOf: edge) + to position) / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback