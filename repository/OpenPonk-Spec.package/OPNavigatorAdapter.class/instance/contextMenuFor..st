widget API
contextMenuFor: anObject
	^ self retrieveContextMenuMapping associations
		select: [ :pair | 
			pair key isBlock
				ifTrue: [ pair key value: anObject ]
				ifFalse: [ anObject isKindOf: pair key ] ]
		thenCollect: #value