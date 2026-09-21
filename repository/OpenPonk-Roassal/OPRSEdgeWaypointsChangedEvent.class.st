"
Event announced on RSCanvas when routing waypoints of an edge/line are modified interactively via control point handles or creator midpoint.
"
Class {
	#name : 'OPRSEdgeWaypointsChangedEvent',
	#superclass : 'RSAbstractMouseEvent',
	#instVars : [
		'line',
		'oldWaypoints',
		'newWaypoints'
	],
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'accessing' }
OPRSEdgeWaypointsChangedEvent >> line [	^ line ifNil: [ shape ]
]

{ #category : 'accessing' }
OPRSEdgeWaypointsChangedEvent >> line: anObject [	line := anObject. shape := anObject
]

{ #category : 'accessing' }
OPRSEdgeWaypointsChangedEvent >> newWaypoints [	^ newWaypoints
]

{ #category : 'accessing' }
OPRSEdgeWaypointsChangedEvent >> newWaypoints: anObject [	newWaypoints := anObject
]

{ #category : 'accessing' }
OPRSEdgeWaypointsChangedEvent >> oldWaypoints [	^ oldWaypoints
]

{ #category : 'accessing' }
OPRSEdgeWaypointsChangedEvent >> oldWaypoints: anObject [	oldWaypoints := anObject
]
