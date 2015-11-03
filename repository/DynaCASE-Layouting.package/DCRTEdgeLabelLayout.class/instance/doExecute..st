hook
doExecute: elementsCollection
	| action |
	action := [ withVisualization
		ifTrue: [ self doExecuteVisualized: elementsCollection ]
		ifFalse: [ self doExecuteNormal: elementsCollection ] ].
	withProgressBar
		ifTrue: [ action asJob run ]
		ifFalse: [ action value ]