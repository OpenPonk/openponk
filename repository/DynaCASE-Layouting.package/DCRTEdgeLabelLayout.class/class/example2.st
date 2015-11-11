examples
example2
|v es edges lines utils edgeLabels|
utils := DCLayoutUtils new.
v := RTView new.
v @ RTDraggableView.
v @ RTZoomableView.

es := RTBox new size: 30; elementsOn: #(A B).
v addAll: es.
es do: [ :each | |lbl|
	lbl := RTLabel new color: Color black; elementOn: each model.
	TRConstraint stick: lbl onTheCenterOf: each.
	v add: lbl.
].
"es @ RTDraggable."

lines := {
	{ #A -> #B . 'XX' }.
}.

edgeLabels := OrderedCollection new.

edges := (lines collect: [ :each | |e lbl|
	e := RTArrowedLine new
		color: Color black;
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: (es elementFromModel: each first key)
		to: (es elementFromModel: each first value).
	e model: each second.
	v add: e.
	lbl := RTLabel new color: Color blue; text: [ :model | model model ]; elementOn: e.
	TRConstraint 
							stick: lbl 
							between: e from trachelShape 
							and: e to trachelShape
							offset: 0.5. 
	v add: lbl.
	edgeLabels add: lbl.
	e.
]) asGroup.

(es elementFromModel: #B) translateBy: 150 @ 0.

DCRTEdgeLabelLayout new
	spacing: 90;
	labels: edgeLabels;
"	labels: {edgeLabels last};"
	on: es edges: edges.
	
v canvas camera focusOnCenterScaled: (450.0@700.0).

v