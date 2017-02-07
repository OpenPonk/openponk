hooks
renderIn: aView
	| element |
	element := block cull: aView.
	element view ifNil: [ element renderIn: aView ].
	^ element