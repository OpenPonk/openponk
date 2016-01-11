examples
example
	|v es e visible|
v := RTView new.
es := (RTEllipse new color: Color black; size: 20; elementsOn: #(1 2)).
e := DCRTStyledConnection new
	decorate: [ :deco |
		deco
			dashdotLine;
			emptyDiamondTail;
			filledArrowHead
	];
	withContinuousRectangleAttachPoint;
	color: Color red;
	edgeFrom: es first to: es second.
	e shape addPoint: -50 @ 10.
e shape addPoint: -50 @ 80.
e shape addPoint: 200 @ 80.
e shape addPoint: 200 @ 10.
v addAll: es; add: e.
es @ RTDraggable.
RTHorizontalLineLayout new horizontalGap: 100; on: es.
visible := false.
e @ DCRTConnectionHandles.

v open