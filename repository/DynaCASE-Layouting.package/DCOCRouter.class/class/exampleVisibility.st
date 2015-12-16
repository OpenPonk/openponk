examples
exampleVisibility
	|v es router visGraph g e seg|
v := RTView new.
v @ (RTGridView new gridSize: 10).

es := RTBox new size: #yourself; elementsOn: #(20 40 60 40).

v addAll: es.

es @ RTDraggable.

es second translateTo: 100 @ 50.
es third translateTo: 200 @ 30.
es fourth translateTo: 90 @ -80.

router := DCOCRouter new.
visGraph := router visibilityGraphFor: es.

g := RTGroup new.

visGraph nodes do: [ :each |
	e := RTEllipse new color: Color red; size: 2; elementOn: each.
	g add: e.
	v add: e.
	e translateTo: each model.
].

visGraph edges do: [ :each |
	seg := RTLine new
		color: Color lightRed;
		edgeFrom: (g elementFromModel: each from) to: (g elementFromModel: each to).
	v add: seg.
	seg trachelShape pushBack.
].

v @ RTDraggableView @ RTZoomableView.

v