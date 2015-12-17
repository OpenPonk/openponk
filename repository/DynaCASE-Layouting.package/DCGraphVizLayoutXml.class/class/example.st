example
example
	|v es a b c|
v := RTView new.
es := RTBox new width: #x; height: #y; color: Color transparent; borderColor: Color black; elementsOn: { 150 @ 20 . 40 @ 15 . 20 @ 30 }.
v addAll: es.
es @ (RTLabelled new center).

a := DCRTStyledConnection new withContinuousRectangleAttachPoint; decorate: [ :decorator | decorator arrowHead ]; color: Color black; edgeFrom: es first to: es second.
b := DCRTStyledConnection new withContinuousRectangleAttachPoint; color: Color black; edgeFrom: es second to: es third.
c := DCRTStyledConnection new withContinuousRectangleAttachPoint; color: Color black; edgeFrom: es first to: es third.

v add: a; add: b; add: c.
v edges do: [ :each | each @ DCRTConnectionHandles ].

es second translateTo: 100 @ -50.
es third translateTo: 50 @ 100.

DCGraphVizLayout new on: es directed: {a} undirected: {b . c}.

v @ RTEmptyViewContextInteraction @ RTZoomableView @ RTDraggableView.