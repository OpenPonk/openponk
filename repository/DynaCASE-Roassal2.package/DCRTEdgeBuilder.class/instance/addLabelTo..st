public
addLabelTo: anEdge
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
					anEdge labels remove: label.
					label remove ]).
	anEdge labels add: label.
	anEdge view add: label.
	^ label