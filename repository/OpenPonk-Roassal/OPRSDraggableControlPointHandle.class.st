Class {
	#name : 'OPRSDraggableControlPointHandle',
	#superclass : 'OPRSAbstractDraggableControlPointHandle',
	#instVars : [
		'indexOfControlPoint'
	],
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'actions' }
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

	line announce: OPRSDraggedControlPointsEvent new
]

{ #category : 'rendering' }
OPRSDraggableControlPointHandle >> constraint [

	| moveBlock |
	moveBlock := [ self updatePosition ].
	moveBlock value.
	line from when: RSPositionChangedEvent do: moveBlock for: self.
	line to when: RSPositionChangedEvent do: moveBlock for: self.
	line from when: RSExtentChangedEvent do: moveBlock for: self.
	line to when: RSExtentChangedEvent do: moveBlock for: self
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> controlPoint [

	^ line controlPoints at: indexOfControlPoint
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> on: aLine atControlPoint: anIndex [

	line := aLine.
	indexOfControlPoint := anIndex
]

{ #category : 'actions' }
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
	
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> remove [

	self removeConnectedEdges.
	super remove
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> removeConnectedEdges [
	"remove connected edges without triggering removal cascade"
	shape connectedLines removeAll
]

{ #category : 'actions' }
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

{ #category : 'rendering' }
OPRSDraggableControlPointHandle >> render [

	shape := self createShape.
	shape model: line.
	clickBox := self createClickBoxShape.
	clickBox model: line.
	line canvas
		add: shape;
		add: clickBox.
	self constraint.
	RSLocation new stick: shape on: clickBox.
	clickBox @ RSDraggable.

	shape
		when: RSPositionChangedEvent
		do: [ :event | self changedPositionBy: event ]
		for: self.

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
	clickBox when: RSMouseDragEnd do: [ self onDragEnd ] for: self
]

{ #category : 'shapes' }
OPRSDraggableControlPointHandle >> size [

	^ 9
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> straightenConnection [
	"Remove all the handles of the connection"

	line controlPoints ifEmpty: [ ^ self ].
	line innerControlPoints: #(  ).
	(line propertyAt: OPRSDraggableControlPoints) rebuild
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> updatePosition [

	clickBox translateTo: self controlPoint
]
