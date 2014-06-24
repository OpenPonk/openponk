event handling
nodeDeleted: anEvent
	(content includes: anEvent node)
		ifTrue: [ content remove: anEvent node ]