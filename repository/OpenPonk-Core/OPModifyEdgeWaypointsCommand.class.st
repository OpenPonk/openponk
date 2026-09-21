"
Reversible command recording and applying changes to routing waypoints of an OPEdge. Safely copies waypoint collections to prevent reference aliasing and ensures OPRSDraggableControlPoints rebuilds handles upon rollback.
"
Class {
	#name : 'OPModifyEdgeWaypointsCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'edge',
		'oldWaypoints',
		'newWaypoints'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPModifyEdgeWaypointsCommand class >> edge: anEdge oldWaypoints: anOldCollection newWaypoints: aNewCollection [
	^ self new
		edge: anEdge
		oldWaypoints: anOldCollection
		newWaypoints: aNewCollection;
		yourself
]

{ #category : 'executing' }
OPModifyEdgeWaypointsCommand >> applyWaypoints: aCollection [
	| targetLine controlPointsInteraction |
	edge waypoints: aCollection copy.
	edge isRendered ifFalse: [ ^ self ].
	targetLine := edge roassalShape.
	controlPointsInteraction := targetLine
		propertyAt: OPRSDraggableControlPoints
		ifAbsent: [ nil ].
	controlPointsInteraction
		ifNotNil: [ controlPointsInteraction updateDuring: [ edge updateRenderFromSelf ] ]
		ifNil: [ edge updateRenderFromSelf ]
]

{ #category : 'accessing' }
OPModifyEdgeWaypointsCommand >> edge: anEdge oldWaypoints: anOldCollection newWaypoints: aNewCollection [
	edge := anEdge.
	oldWaypoints := anOldCollection asArray copy.
	newWaypoints := aNewCollection asArray copy
]

{ #category : 'executing' }
OPModifyEdgeWaypointsCommand >> execute [
	self applyWaypoints: newWaypoints
]

{ #category : 'executing' }
OPModifyEdgeWaypointsCommand >> undo [
	self applyWaypoints: oldWaypoints
]
