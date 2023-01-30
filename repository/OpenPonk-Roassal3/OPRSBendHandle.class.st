Class {
	#name : #OPRSBendHandle,
	#superclass : #OPRSHandle,
	#instVars : [
		'index',
		'position'
	],
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #accessing }
OPRSBendHandle >> changedPositionBy: anEvent [

	position := anEvent newPosition.
	line controlPoints: (line controlPoints copy
			 replaceAll: anEvent oldPosition
			 with: anEvent newPosition).
	line announce: (OPRSHandleMoved new
			 oldPosition: anEvent oldPosition;
			 newPosition: anEvent newPosition;
			 yourself)
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> on: aLine at: aPosition [
	line := aLine.
	position := aPosition
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> onDragEnd [

	| previous next currentIndex |
	"remove the point if the angle between the two adjacent lines is near Pi"
	currentIndex := line controlPoints detectIndex: [ :each | 
		                each closeTo: position absolutePrecision: 0.99 ].
	previous := currentIndex = 1
		            ifTrue: [ line from position ]
		            ifFalse: [ line controlPoints at: currentIndex - 1 ].
	next := currentIndex = line controlPoints size
		        ifTrue: [ line to position ]
		        ifFalse: [ line controlPoints at: currentIndex + 1 ].

	(position
		 onLineFrom: previous
		 to: next
		 within: (next distanceTo: previous) * 0.03 + 4) ifTrue: [ 
		^ self removePoint ].
	shape pushFront
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> position [
	^ position
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> remove [

	self removeConnectedEdges.
	super remove.
	position := nil
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> removeConnectedEdges [
	"remove connected edges without triggering removal cascade"
	shape connectedEdges removeAll
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> removePoint [

	"destroy the handle and the underlying point"

	| controlPointIndex |
	line controlPoints ifEmpty: [ ^ self ].
	controlPointIndex := line controlPoints
		                     indexOf: position
		                     ifAbsent: [ ^ self ].
	line controlPoints:
		(line controlPoints first: controlPointIndex - 1)
		, (line controlPoints allButFirst: controlPointIndex).

	(line propertyAt: OPRSPolylineHandles) rebuild
]

{ #category : #accessing }
OPRSBendHandle >> render [

	shape := self createShape.
	shape model: line.
	clickBox := self createClickBoxShape.
	clickBox model: line.
	line canvas
		add: shape;
		add: clickBox.
	clickBox translateTo: position.
	RSLocation new stick: shape on: clickBox.
	clickBox @ RSDraggable.
	shape addConnectedEdge: line.
	shape @ (RSMenuActivable new menuDo: [ :menu :box | 
		 menu
			 add: 'Remove point'
			 target: self
			 selector: #removePoint
			 argument: #(  );
			 add: 'Straighten line'
			 target: self
			 selector: #straightenConnection
			 argument: #(  ) ]).
	shape
		when: RSPositionChangedEvent
		do: [ :event | self changedPositionBy: event ].
	clickBox when: RSMouseDragEnd do: [ self onDragEnd ]
]

{ #category : #accessing }
OPRSBendHandle >> size [

	^ 9
]

{ #category : #'as yet unclassified' }
OPRSBendHandle >> straightenConnection [

	"Remove all the handles of the connection"

	line controlPoints ifEmpty: [ ^ self ].
	line controlPoints: { 
			line controlPoints first.
			line controlPoints last }.
	(line propertyAt: OPRSPolylineHandles) rebuild
]
