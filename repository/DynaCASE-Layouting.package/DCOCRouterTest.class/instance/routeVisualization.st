as yet unclassified
routeVisualization
|v p route pstr|
v := RTView new.
pstr := [ :aPoint | aPoint x asString, ',', aPoint y asString ].
route := {0@0 . 10@0 . 10@20 . 50 @ 20 . 50 @ 40}.

p := String streamContents: [ :s |
	s
		nextPutAll: 'M';
		nextPutAll: (pstr value: route first).
	route allButFirstDo: [ :each |
		s
			nextPutAll: ' L';
			nextPutAll: (pstr value: each).
	].
].
v add: (RTSVGPath new path: p; element).
route do: [ :each |
	v add: ((RTEllipse new color: Color white; borderColor: Color black; size: 2; elementOn: each) translateTo: each).
].

"v add: (RTBox new size: 0; element)." "<- broken without this"
v @ RTZoomableView @ RTDraggableView.