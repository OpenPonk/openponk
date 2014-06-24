event handling
nodeSelected: anEvent
	anEvent node type = #Text
		ifTrue: [ 
			node := anEvent node.
			self nameField text: anEvent node text ].
	anEvent node type = #VisualVertex
		ifTrue: [ 
			node := anEvent node.
			self nameField text: anEvent node text ].
	anEvent node type = #VisualTransition
		ifTrue: [ 
			node := anEvent node caption.
			self nameField text: anEvent node text ]