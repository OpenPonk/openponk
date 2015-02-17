examples
example
	| v b1 b2 edges |
	b1 := (RTBox new
		size: 150;
		element)
		translateTo: 0 @ 0;
		@ RTDraggable.
	b2 := (RTBox new
		size: 150;
		element)
		translateTo: 400 @ 0;
		@ RTDraggable.
	edges := OrderedCollection new.
	edges add: ((RTArrowedLine new head: DCRTFilledDiamond asHead; color: Color black; width: 2; attachPoint: (RTShorterDistanceWithOffsetAttachPoint new offset: 15)) edgeFrom: b1 to: b2).
	edges add: ((DCRTDecoratedLine new color: Color blue; width: 2; attachPoint: (RTShorterDistanceWithOffsetAttachPoint new offset: 15)) edgeFrom: b1 to: b2).
	edges add: ((DCRTDecoratedLine new filledDiamondHead; color: Color green; width: 2; attachPoint: (RTShorterDistanceWithOffsetAttachPoint new offset: 15)) edgeFrom: b1 to: b2).
	edges add: ((DCRTDecoratedLine new filledDiamondHead; emptyCircleTail; color: Color red; width: 2; attachPoint: (RTShorterDistanceWithOffsetAttachPoint new offset: 15)) edgeFrom: b1 to: b2).
	v := RTView new
		add: b1;
		add: b2;
		addAll: edges.
	edges do: [ :each | each update ].
	v open