event handling
nodeDeselected: anEvent
	anEvent node type = #Text
		ifTrue: [ 
			node := nil.
			self nameField text: '' ].
	anEvent node type = #VisualVertex
	ifTrue: [ 
			node := nil.
			self nameField text: '' ].	
		anEvent node type = #VisualTransition
	ifTrue: [ 
			node := nil.
			self nameField text: '' ].	