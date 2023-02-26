Class {
	#name : #OPRSDraggableControlPointHandle,
	#superclass : #OPRSAbstractDraggableControlPointHandle,
	#instVars : [
		'indexOfControlPoint'
	],
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #accessing }
OPRSDraggableControlPointHandle >> changedPositionBy: anEvent [

	line
		controlPoints: (line controlPoints
				 copyReplaceFrom: indexOfControlPoint
				 to: indexOfControlPoint
				 with: { anEvent newPosition });
		update.

	line
		propertyAt: OPRSDraggableCPController
		put: line from encompassingRectangle copy.

	line announce: (OPRSDraggedControlPointsEvent new
			 oldPosition: anEvent oldPosition;
			 newPosition: anEvent newPosition;
			 yourself)
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> controlPoint [

	^ line controlPoints at: indexOfControlPoint
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> on: aLine atControlPoint: anIndex [

	line := aLine.
	indexOfControlPoint := anIndex
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> onDragEnd [

	| previous next |
	"remove the point if the angle between the two adjacent lines is near Pi"
	previous := line controlPoints at: indexOfControlPoint - 1.
	next := line controlPoints at: indexOfControlPoint + 1.

	(self controlPoint
		 onLineFrom: previous
		 to: next
		 within: (next distanceTo: previous) * 0.03 + 4) ifTrue: [ 
		^ self removePoint ].
	shape pushFront
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> remove [

	self removeConnectedEdges.
	super remove
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> removeConnectedEdges [
	"remove connected edges without triggering removal cascade"
	shape connectedLines removeAll
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> removePoint [

	"destroy the handle and the underlying point"

	line controlPoints ifEmpty: [ ^ self ].
	(line from = line to and: [ line controlPoints size <= 4 ]) ifTrue: [ 
		^ self ].
	line controlPoints:
		(line controlPoints first: indexOfControlPoint - 1)
		, (line controlPoints allButFirst: indexOfControlPoint).

	(line propertyAt: OPRSDraggableControlPoints) rebuild
]

{ #category : #accessing }
OPRSDraggableControlPointHandle >> render [

	shape := self createShape.
	shape model: line.
	clickBox := self createClickBoxShape.
	clickBox model: line.
	line canvas
		add: shape;
		add: clickBox.
	clickBox translateTo: self controlPoint.
	RSLocation new stick: shape on: clickBox.
	clickBox @ RSDraggable.

	shape
		when: RSPositionChangedEvent
		do: [ :event | self changedPositionBy: event ].
	line from = line to ifTrue: [ 
		line from when: RSPositionChangedEvent do: [ :event | 
			clickBox translateBy: event newPosition - event oldPosition ] ].
	(line from ~= line to or: [ line controlPoints size > 4 ]) ifTrue: [ 
		shape @ (RSMenuActivable new menuDo: [ :menu :box | 
			 menu
				 add: 'Remove point'
				 target: self
				 selector: #removePoint
				 argument: #(  );
				 add: 'Straighten line'
				 target: self
				 selector: #straightenConnection
				 argument: #(  ) ]) ].
	clickBox when: RSMouseDragEnd do: [ self onDragEnd ]
]

{ #category : #accessing }
OPRSDraggableControlPointHandle >> size [

	^ 9
]

{ #category : #'as yet unclassified' }
OPRSDraggableControlPointHandle >> straightenConnection [

	"Remove all the handles of the connection"

	line controlPoints ifEmpty: [ ^ self ].
	line controlPoints: { 
			line controlPoints first.
			line controlPoints last }.
	(line propertyAt: OPRSDraggableControlPoints) rebuild
]
