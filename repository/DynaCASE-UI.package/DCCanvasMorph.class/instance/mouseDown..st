event handling
mouseDown: anEvent
	| node |
	anEvent redButtonPressed
		ifTrue: [ 
			node := content detect: [ :item | item containsPoint: anEvent cursorPoint - self positionInWorld ] ifNone: [ nil ].
			node
				ifNil: [ self selectNode: nil ]
				ifNotNil: [ 
					|subnode|
					subnode := node subnodes detect:[ :item | item containsPoint: anEvent cursorPoint - self positionInWorld ] ifNone: [ nil ].
					subnode
						ifNotNil: [ node := subnode ].
					draggedNode := node.
					content remove: node.
					content addFirst: node.
					self selectNode: node ].
			self changed ]