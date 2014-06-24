event handling
handleKeystroke: anEvent
	| keyValue |
	keyValue := anEvent keyValue.
	keyValue = 127 "Delete"
		ifTrue: [ self deleteSelectedNode ]