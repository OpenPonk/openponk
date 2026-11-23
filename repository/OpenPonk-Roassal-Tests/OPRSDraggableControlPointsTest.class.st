"
Unit tests verifying interactive control-point and midpoint-creator handle lifecycle, canvas selection integration, and waypoint modification guards.
"
Class {
	#name : 'OPRSDraggableControlPointsTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'sourceBox',
		'targetBox',
		'polyline',
		'interaction'
	],
	#category : 'OpenPonk-Roassal-Tests-Polyline',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Polyline'
}

{ #category : 'running' }
OPRSDraggableControlPointsTest >> setUp [

	super setUp.
	canvas := RSCanvas new.
	sourceBox := RSBox new
		             size: 20;
		             translateTo: 0 @ 0;
		             yourself.
	targetBox := RSBox new
		             size: 20;
		             translateTo: 100 @ 0;
		             yourself.
	polyline := RSPolyline new
		            from: sourceBox;
		            to: targetBox;
		            controlPoints: {
				            (0 @ 0).
				            (50 @ 40).
				            (100 @ 0) };
		            yourself.
	canvas
		add: sourceBox;
		add: targetBox;
		add: polyline.
	interaction := OPRSDraggableControlPoints new
]

{ #category : 'running' }
OPRSDraggableControlPointsTest >> tearDown [

	(interaction isNotNil and: [ polyline isNotNil and: [ polyline hasProperty: OPRSDraggableControlPoints ] ]) ifTrue: [
		interaction remove ].
	interaction := nil.
	polyline := nil.
	sourceBox := nil.
	targetBox := nil.
	canvas := nil.
	super tearDown
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testAnnounceWaypointsChangedIgnoresUnchangedWaypoints [

	| announcedEvents waypoints |
	polyline addInteraction: interaction.
	announcedEvents := OrderedCollection new.
	canvas announcer when: OPRSEdgeWaypointsChangedEvent do: [ :event | announcedEvents add: event ] for: self.
	waypoints := polyline controlPoints copy.
	interaction announceWaypointsChangedFor: polyline old: waypoints new: waypoints copy.
	self assertEmpty: announcedEvents
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testBezierWithFourControlPointsSkipsMidpointHandles [

	| bezier bezierInteraction |
	bezier := OPRSBezier new
		          from: sourceBox;
		          to: targetBox;
		          controlPoints: {
				          (0 @ 0).
				          (30 @ 50).
				          (70 @ 50).
				          (100 @ 0) };
		          yourself.
	canvas add: bezier.
	bezierInteraction := OPRSDraggableControlPoints new.
	bezier addInteraction: bezierInteraction.
	bezierInteraction showHandles.
	self assert: bezierInteraction handles size equals: 2.
	self assertEmpty: bezierInteraction midpointHandles.
	bezierInteraction remove
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testConnectWithCanvasWithoutSelectableCanvasShowsAndRemovesHandlesOnClick [

	polyline addInteraction: interaction.
	self assertEmpty: interaction handles.
	polyline announce: RSMouseLeftClick new.
	self assert: interaction handles size equals: 1.
	self assert: interaction midpointHandles size equals: 2.
	canvas announce: (RSMouseLeftClick new
			 shape: sourceBox;
			 yourself).
	self assertEmpty: interaction handles.
	self assertEmpty: interaction midpointHandles
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testControlPointHandleGuardsForEmptyAndSelfLoopAndNilLine [

	| handle selfLoop selfLoopInteraction selfHandle |
	polyline addInteraction: interaction.
	interaction showHandles.
	handle := interaction handles first.

	handle onDragEnd: RSMouseDragEnd new.
	self assert: polyline controlPoints size equals: 3.

	polyline controlPoints: #(  ).
	handle basicRemovePoint.
	handle straightenConnection.
	self assertEmpty: polyline controlPoints.

	interaction removeHandles.
	handle onDragEnd: RSMouseDragEnd new.
	self assert: handle shape identicalTo: nil.

	selfLoop := RSPolyline new
		            from: sourceBox;
		            to: sourceBox;
		            controlPoints: {
				            (0 @ -10).
				            (0 @ -40).
				            (40 @ 0).
				            (10 @ 0) };
		            yourself.
	canvas add: selfLoop.
	selfLoopInteraction := OPRSDraggableControlPoints new.
	selfLoop addInteraction: selfLoopInteraction.
	selfLoopInteraction showHandles.
	selfHandle := selfLoopInteraction handles first.
	selfHandle basicRemovePoint.
	self assert: selfLoop controlPoints size equals: 4.
	selfLoopInteraction remove
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testControlPointHandleMenuForSelfLoopAndRegularLine [

	| handle menuActivable menu selfLoopFour selfLoopFourInteraction selfLoopFive selfLoopFiveInteraction |
	polyline addInteraction: interaction.
	interaction showHandles.
	handle := interaction handles first.
	menuActivable := (handle shape announcer subscriptions subscriptions detect: [ :each | each subscriber isKindOf: RSMenuActivable ])
		                 subscriber.
	menu := MenuMorph new.
	(menuActivable instVarNamed: #menuBlock) value: menu value: handle shape.
	self assert: (menu items collect: #contents as: Array) equals: #( 'Remove point' 'Straighten line' ).
	self assert: (menu items collect: #selector as: Array) equals: #( #removePoint #straightenConnection ).

	selfLoopFour := RSPolyline new
		                from: sourceBox;
		                to: sourceBox;
		                controlPoints: {
				                (0 @ -10).
				                (0 @ -40).
				                (40 @ 0).
				                (10 @ 0) };
		                yourself.
	canvas add: selfLoopFour.
	selfLoopFourInteraction := OPRSDraggableControlPoints new.
	selfLoopFour addInteraction: selfLoopFourInteraction.
	selfLoopFourInteraction showHandles.
	self
		assert: (selfLoopFourInteraction handles first shape announcer subscriptions subscriptions noneSatisfy: [ :each |
				 each subscriber isKindOf: RSMenuActivable ])
		description: 'Self-loop with 4 control points should not offer point removal menu'.
	selfLoopFourInteraction remove.

	selfLoopFive := RSPolyline new
		                from: sourceBox;
		                to: sourceBox;
		                controlPoints: {
				                (0 @ -10).
				                (0 @ -40).
				                (40 @ -40).
				                (40 @ 0).
				                (10 @ 0) };
		                yourself.
	canvas add: selfLoopFive.
	selfLoopFiveInteraction := OPRSDraggableControlPoints new.
	selfLoopFive addInteraction: selfLoopFiveInteraction.
	selfLoopFiveInteraction showHandles.
	self
		assert: (selfLoopFiveInteraction handles first shape announcer subscriptions subscriptions anySatisfy: [ :each |
				 each subscriber isKindOf: RSMenuActivable ])
		description: 'Self-loop with more than 4 control points should offer point removal menu'.
	selfLoopFiveInteraction remove
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testControlPointHandleRemovePointAndStraightenWithoutInteractionProperty [

	| handle |
	polyline addInteraction: interaction.
	interaction showHandles.
	handle := interaction handles first.
	polyline removeKey: OPRSDraggableControlPoints.
	handle removePoint.
	self assert: polyline controlPoints size equals: 2.

	polyline controlPoints: {
			(0 @ 0).
			(50 @ 40).
			(100 @ 0) }.
	handle straightenConnection.
	self assertEmpty: polyline innerControlPoints
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testCreatorHandleShortSegmentSkipsPromoteAndConditionDrag [

	| nearTarget shortLine shortInteraction creatorHandle |
	nearTarget := RSBox new
		              size: 4;
		              translateTo: 6 @ 0;
		              yourself.
	shortLine := RSPolyline new
		             from: sourceBox;
		             to: nearTarget;
		             controlPoints: {
				             (0 @ 0).
				             (6 @ 0) };
		             yourself.
	canvas
		add: nearTarget;
		add: shortLine.
	shortInteraction := OPRSDraggableControlPoints new.
	shortLine addInteraction: shortInteraction.
	shortInteraction showHandles.
	creatorHandle := shortInteraction midpointHandles first.
	creatorHandle basicPromote.
	creatorHandle promote.
	self assert: shortLine controlPoints size equals: 2.
	creatorHandle clickBox announce: (RSMouseDragging new
			 step: 10 @ 10;
			 yourself).
	self assert: shortLine controlPoints size equals: 2.
	shortInteraction remove
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testOnShapeDefersEnableUntilAddedToCanvasAndRemoveBeforeAdd [

	| detachedLine detachedInteraction unaddedLine unaddedInteraction |
	detachedLine := RSPolyline new
		                from: sourceBox;
		                to: targetBox;
		                controlPoints: {
				                (0 @ 0).
				                (100 @ 0) };
		                yourself.
	detachedInteraction := OPRSDraggableControlPoints new.
	detachedLine addInteraction: detachedInteraction.
	self
		deny: (detachedLine hasProperty: OPRSDraggableControlPoints)
		description: 'Interaction should wait for RSShapeAddedEvent before enabling'.
	canvas add: detachedLine.
	self assert: (detachedLine propertyAt: OPRSDraggableControlPoints) identicalTo: detachedInteraction.
	detachedInteraction remove.

	unaddedLine := RSPolyline new
		               from: sourceBox;
		               to: targetBox;
		               yourself.
	unaddedInteraction := OPRSDraggableControlPoints new.
	unaddedLine addInteraction: unaddedInteraction.
	unaddedInteraction remove.
	self
		deny: (unaddedLine announcer subscriptions subscriptions anySatisfy: [ :each | each subscriber == unaddedInteraction ])
		description: 'Removing interaction before canvas add should unsubscribe from line'
]

{ #category : 'tests' }
OPRSDraggableControlPointsTest >> testShowHandlesIdempotentAndRebuildWhenInactive [

	polyline addInteraction: interaction.
	interaction rebuild.
	self assertEmpty: interaction handles.
	interaction showHandles.
	self assert: interaction handles size equals: 1.
	interaction showHandles.
	self assert: interaction handles size equals: 1
]
