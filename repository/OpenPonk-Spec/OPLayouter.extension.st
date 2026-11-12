Extension { #name : 'OPLayouter' }

{ #category : '*OpenPonk-Spec' }
OPLayouter class >> supportedLayoutCommands [
	^ {OPDominanceTreeLayoutCommand.
	OPGridLayoutCommand.
	OPSugiyamaLayoutCommand.
	OPTreeLayoutCommand}
]
