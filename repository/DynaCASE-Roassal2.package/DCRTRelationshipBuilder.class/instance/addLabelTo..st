public
addLabelTo: anEdge
	| label |
	label := (RTLabel new
		color: self defaultColor;
		element) @ RTDraggable.
	label model: anEdge.
	anEdge trachelShape addCallback: (TRRemoveCallback new block: [ :shape | label remove ]).
	anEdge view add: label.
	^ label