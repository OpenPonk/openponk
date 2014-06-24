event handling
nodeAdded: anEvent
	(content includes: anEvent node container)
		ifTrue: [ content addFirst: anEvent node ]