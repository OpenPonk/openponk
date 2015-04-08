running
setUp
	| shape |
	shape := RTBox new size: 40.
	(e1 := shape element)
		translateTo: 0 @ 0;
		@ RTDraggable.
	(e2 := shape element)
		translateTo: 100 @ 0;
		@ RTDraggable.
	(e3 := shape element)
		translateTo: 0 @ 100;
		@ RTDraggable.
	(e4 := shape element)
		translateTo: 100 @ 100;
		@ RTDraggable.
	(e5 := shape element)
		translateTo: -100 @ -100;
		@ RTDraggable.
	builder := DCStarAssociationBuilder new