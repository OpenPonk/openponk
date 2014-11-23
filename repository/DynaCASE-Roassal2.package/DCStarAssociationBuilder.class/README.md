A DCStarAssociation is handler for association between multiple elements.

example:

|v e1 e2 e3 e4 e5 s|
v := RTView new.
e1 := ((RTBox new size: 20; element) translateTo: 100@0; yourself).
e1 @ RTDraggable.
v add: e1.
e2 := ((RTBox new size: 20; element) translateTo: 0@0; yourself).
e2 @ RTDraggable.
v add: e2 .
e3 := ((RTBox new size: 20; element) translateTo: -100@0; yourself).
e3 @ RTDraggable.
v add: e3.
e4 := ((RTBox new size: 20; element) translateTo: 0@ -200; yourself).
e4 @ RTDraggable.
v add: e4.
e5 := ((RTBox new size: 20; element) translateTo: 100@ -200; yourself).
e5 @ RTDraggable.
v add: e5.
s := DCStarAssociation new.
s sourcesEdgeBuilder: [ :from :to | DCRTMultiLine new attachPoint: RTShorterDistanceWithOffsetAttachPoint instance; edgeFrom: from to: to].
s targetsEdgeBuilder: [ :from :to | DCRTMultiLine new attachPoint: RTShorterDistanceWithOffsetAttachPoint instance; emptyArrowHead; edgeFrom: from to: to ].
"s centeringBlock: [ :srcs :tgts | tgts anyOne position + (0@100) ]."
s addSource: e1; addSource: e2; addSource: e3; addSource: e4; addTarget: e5.
v open.