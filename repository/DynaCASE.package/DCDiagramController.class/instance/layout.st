accessing
layout
	| layoutControllers layout |
	layoutControllers := self controllers select: [ :each | each figure isKindOf: RTElement ].
	layout := Dictionary new.
	layoutControllers do: [ :each | layout at: each model name put: each figure position ].
	^ layout