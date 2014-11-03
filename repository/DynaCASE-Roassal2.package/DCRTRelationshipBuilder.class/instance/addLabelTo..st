public
addLabelTo: anEdge
	| label |
	label := (RTLabel new
		height: 10;
		color: self defaultColor;
		element) @ RTDraggable.
	label model: anEdge.
	anEdge trachelShape addCallback: (TRRemoveCallback new block: [ :shape | label remove ]).
	anEdge view add: label.
	^ label