accessing
writeVertexCoordinates: aVertex
	| box width height |
	width := 20.
	height := 20.
	box := aVertex layout boundingBox.
	(aVertex model isMemberOf: DCSmState)
		ifTrue: [ 
			width := box width.
			height := box height ].
	(aVertex model isMemberOf: DCSmPseudostate)
		ifTrue: [ 
			aVertex kind = DCSmPseudostateKind choice
				ifTrue: [ 
					width := 40.
					height := 40 ] ].
	writer
		tag: 'coordinates'
		with: [ 
			writer tag: #x with: box origin x.
			writer tag: #y with: box origin y.
			writer tag: #w with: width.
			writer tag: #h with: height ]