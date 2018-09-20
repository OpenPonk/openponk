Class {
	#name : #DCOCRouterTest,
	#superclass : #TestCase,
	#instVars : [
		'router'
	],
	#category : 'DynaCASE-Layouting-OCR'
}

{ #category : #'as yet unclassified' }
DCOCRouterTest >> routeVisualization [
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
]

{ #category : #running }
DCOCRouterTest >> setUp [
	router := DCOCRouter new
]

{ #category : #tests }
DCOCRouterTest >> testCollinearizeRoute [
	self
		assert: (router class collinearizeRoute: {0@0 . 10@0 . 10@10 . 10@20 . 30@20 . 50 @ 20 . 50 @ 40})
		equals: {0@0 . 10@0 . 10@20 . 50 @ 20 . 50 @ 40}
]

{ #category : #tests }
DCOCRouterTest >> testInterestingPoint [
	| e |
	e := RTBox new
		width: 40;
		height: 20;
		element.
	"
	-30 @ -20 . 0 @ -20 . 30 @ -20.
	-30 @   0 .           30 @   0.
	-30 @  20 . 0 @  20 . 30 @  20."
	self
		assert: (router interestingPointFor: e) asSet
		equals:
			{(-30 @ -20).
			(0 @ -20).
			(30 @ -20).
			(-30 @ 0).
			(30 @ 0).
			(-30 @ 20).
			(0 @ 20).
			(30 @ 20)} asSet
]
