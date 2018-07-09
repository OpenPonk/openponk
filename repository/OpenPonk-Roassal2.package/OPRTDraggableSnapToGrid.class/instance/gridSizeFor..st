accessing
gridSizeFor: anElement
	anElement view
		ifNotNil: [ :v | 
			(v hasAttribute: #RTGridView)
				ifTrue: [ ^ (v attributeAt: #RTGridView) gridSize ] ].
	^ self gridSize