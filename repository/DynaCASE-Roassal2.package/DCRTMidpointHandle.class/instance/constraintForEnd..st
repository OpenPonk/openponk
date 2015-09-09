as yet unclassified
constraintForEnd: anElement
	| moveBlock b callback |
	moveBlock := [ anElement translateTo: ((edge shape attachPoint endingPointOf: edge) + from position) / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback