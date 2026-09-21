"
Unit tests verifying the calculation of routing points, particularly focusing on self-loops and their distance offsets, within OPRSDraggableCPController.
"
Class {
	#name : 'OPRSDraggableCPControllerTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'boxFrom',
		'selfLine'
	],
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRSDraggableCPControllerTest >> setUp [

	super setUp.

	boxFrom := RSBox new.
	selfLine := RSPolyline new.
	controller := OPRSDraggableCPController new.
	selfLine controlPointsController: controller.
	selfLine
		from: boxFrom;
		to: boxFrom
]

{ #category : 'tests' }
OPRSDraggableCPControllerTest >> testCollinearDragRemovesPointWithoutCrashingOnRemovedHandle [
	| testCanvas boxA boxB polyline interaction handle dragEndEvent |
	testCanvas := RSCanvas new.
	boxA := RSBox new size: 20; position: 0 @ 0.
	boxB := RSBox new size: 20; position: 100 @ 0.
	polyline := RSPolyline new
		from: boxA;
		to: boxB;
		controlPoints: { 0 @ 0 . 50 @ 50 . 100 @ 0 }.
	testCanvas add: boxA; add: boxB; add: polyline.

	interaction := OPRSDraggableControlPoints new.
	polyline addInteraction: interaction.
	interaction showHandles.

	handle := (interaction instVarNamed: #handles) detect: [ :eachHandle |
		(eachHandle instVarNamed: #indexOfControlPoint) = 2 ].
	handle instVarNamed: #initialWaypoints put: polyline controlPoints copy.

	"Move the point to collinear position (50 @ 0)"
	polyline controlPoints: { 0 @ 0 . 50 @ 0 . 100 @ 0 }.

	dragEndEvent := RSMouseDragEnd new
		shape: handle;
		yourself.

	handle onDragEnd: dragEndEvent.

	self assert: polyline controlPoints size equals: 2.
	self assert: polyline controlPoints equals: { 0 @ 0 . 100 @ 0 }.
	self assert: (handle instVarNamed: #line) isNil
]

{ #category : 'tests' }
OPRSDraggableCPControllerTest >> testPromoteMidpointDoesNotAnnounceWaypointsChangedEvent [
	| canvas boxA boxB polyline interaction midpointHandle announcedEvents |
	canvas := RSCanvas new.
	boxA := RSBox new size: 20; position: 0 @ 0.
	boxB := RSBox new size: 20; position: 100 @ 0.
	polyline := RSPolyline new
		from: boxA;
		to: boxB;
		controlPoints: { 0 @ 0 . 100 @ 0 }.
	canvas add: boxA; add: boxB; add: polyline.
	interaction := OPRSDraggableControlPoints new.
	polyline addInteraction: interaction.
	interaction showHandles.

	midpointHandle := (interaction instVarNamed: #midpointHandles) first.

	announcedEvents := OrderedCollection new.
	canvas announcer when: OPRSEdgeWaypointsChangedEvent do: [ :event | announcedEvents add: event ] for: self.

	interaction promoteFor: polyline handle: midpointHandle.

	self assertCollection: announcedEvents hasSameElements: #()
]

{ #category : 'tests' }
OPRSDraggableCPControllerTest >> testSelfLoopInitial [

	selfLine update.
	self assert: selfLine controlPoints size equals: 5
]

{ #category : 'tests' }
OPRSDraggableCPControllerTest >> testSelfLoopPreset [

	selfLine controlPoints: {
			boxFrom encompassingRectangle topCenter.
			(boxFrom encompassingRectangle topCenter - (0 @ 100)).
			(boxFrom encompassingRectangle rightCenter + (100 @ 0)).
			boxFrom encompassingRectangle rightCenter }.
	selfLine update.
	self assert: selfLine controlPoints size equals: 4
]
