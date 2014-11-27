example
example
	| shape e1 e2 e3 e4 e5 s view |
	shape := RTBox new size: 40.
	(e1 := shape element)
		translateTo: -100 @ 100;
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
	(view := RTView new)
		add: e1;
		add: e2;
		add: e3;
		add: e4;
		add: e5.
	s := self new.
	s
		sourcesEdgeBuilder: [ :from :to | 
			DCRTMultiLine new
				attachPoint: RTShorterDistanceWithOffsetAttachPoint instance;
				color: Color black;
				edgeFrom: from to: to ].
	s
		targetsEdgeBuilder: [ :from :to | 
			DCRTMultiLine new
				attachPoint: RTShorterDistanceWithOffsetAttachPoint instance;
				color: Color black;
				emptyArrowHead;
				edgeFrom: from to: to ].	"s centeringBlock: [ :srcs :tgts | tgts anyOne position + (0@100) ]."
	s
		addSource: e1;
		addSource: e2;
		addSource: e3;
		addSource: e4;
		addTarget: e5.
	view open