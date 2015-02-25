adding
addLabelNamed: aSymbol to: anEdge
	| label |
	label := (RTLabel new
		height: 10;
		color: self defaultColor;
		text: '';
		element) @ RTDraggable.
	label model: anEdge.
	anEdge trachelShape
		addCallback:
			(TRRemoveCallback new
				block: [ :shape | 
					anEdge labels removeKey: aSymbol.
					label remove ]).
	anEdge labels at: aSymbol put: label.
	anEdge view add: label.
	^ label