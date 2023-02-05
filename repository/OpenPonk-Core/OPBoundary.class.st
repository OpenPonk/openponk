Class {
	#name : #OPBoundary,
	#superclass : #OPDiagramOnlyShape,
	#traits : 'OPTResizableFigureWithText',
	#classTraits : 'OPTResizableFigureWithText classTrait',
	#instVars : [
		'name',
		'dragBoxes',
		'positionOfMainRelativeToDragBoxes',
		'dragBoxUpdateBlocks',
		'baseShape'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'ston-core' }
OPBoundary class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #name )
]

{ #category : #accessing }
OPBoundary >> defaultHeight [
	^ 400
]

{ #category : #accessing }
OPBoundary >> defaultWidth [
	^ 500
]

{ #category : #'as yet unclassified' }
OPBoundary >> dragBoxUpdateBlocks [

	^ dragBoxUpdateBlocks ifNil: [ 
		  dragBoxUpdateBlocks := { 
			                         (#top -> [ :dragBox | 
			                          dragBox
				                          width: self width;
				                          translateTo:
					                          self encompassingRectangle topCenter ]).
			                         (#bottom -> [ :dragBox | 
			                          dragBox
				                          width: self width;
				                          translateTo:
					                          self encompassingRectangle bottomCenter ]).
			                         (#left -> [ :dragBox | 
			                          dragBox
				                          height: self height;
				                          translateTo:
					                          self encompassingRectangle leftCenter ]).
			                         (#right -> [ :dragBox | 
			                          dragBox
				                          height: self height;
				                          translateTo:
					                          self encompassingRectangle rightCenter ]) }
			                         asDictionary ]
]

{ #category : #accessing }
OPBoundary >> draggableOffset [
	^ 5
]

{ #category : #initialization }
OPBoundary >> initialize [
	super initialize.
	name := ''
]

{ #category : #accessing }
OPBoundary >> name [
	^ name
]

{ #category : #accessing }
OPBoundary >> name: aString [
	name := aString
]

{ #category : #'as yet unclassified' }
OPBoundary >> positionOfMainRelativeToDragBoxes [

	^ positionOfMainRelativeToDragBoxes ifNil: [ 
		  positionOfMainRelativeToDragBoxes := { 
			                                       (#top
			                                        -> [ 
			                                        (dragBoxes at: #top)
				                                        position
			                                        + (0 @ (self height / 2)) ]).
			                                       (#bottom
			                                        -> [ 
			                                        (dragBoxes at: #bottom)
				                                        position
			                                        - (0 @ (self height / 2)) ]).
			                                       (#left
			                                        -> [ 
			                                        (dragBoxes at: #left)
				                                        position
			                                        + (self width / 2 @ 0) ]).
			                                       (#right
			                                        -> [ 
			                                        (dragBoxes at: #right)
				                                        position
			                                        - (self width / 2 @ 0) ]) }
			                                       asDictionary ]
]

{ #category : #printing }
OPBoundary >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(''';
		nextPutAll: self name;
		nextPutAll: ''')'
]

{ #category : #actions }
OPBoundary >> pushBack [

	roassalShape pushBack
]

{ #category : #'creating - subelements' }
OPBoundary >> renderBasicShape [

	roassalShape := RSBox new
		                color: Color transparent;
		                width: self defaultWidth;
		                height: self defaultHeight;
		                yourself.
	roassalShape borderDo: [ :border | 
		border
			color: Color gray;
			dashArray: #( 4 ) ]
]

{ #category : #'creating - subelements' }
OPBoundary >> renderShapeDetails [

	| horizonalBoxShape verticalBoxShape |
	horizonalBoxShape := RSBox new
		                     color: Color transparent;
		                     borderColor: Color transparent;
		                     width: self defaultWidth;
		                     height: 2 * self draggableOffset;
		                     yourself.
	verticalBoxShape := horizonalBoxShape copy
		                    width: 2 * self draggableOffset;
		                    height: self defaultHeight;
		                    yourself.
	dragBoxes := { 
		             (#top -> horizonalBoxShape).
		             (#bottom -> horizonalBoxShape copy).
		             (#left -> verticalBoxShape).
		             (#right -> verticalBoxShape copy) } asDictionary.
	dragBoxes associationsDo: [ :each | each value model: each key ].
	self canvas addAll: dragBoxes.
	dragBoxes do: [ :each | 
		each addInteraction: RSDraggable.
		each
			when: RSPositionChangedEvent do: [ self updateAfterDragOf: each ];
			when: RSMouseDragStart
			do: [ :event | roassalShape announce: event copy ];
			when: RSMouseDragEnd
			do: [ :event | roassalShape announce: event copy ] ].
	roassalShape @ OPRSSelectable.
	roassalShape
		when: RSExtentChangedEvent do: [ self updateDragBoxes ];
		when: RSPositionChangedEvent do: [ self updateDragBoxes ].
	roassalShape @ OPRSResizable .
	self renderLabel
]

{ #category : #hooks }
OPBoundary >> text [
	^ self name
]

{ #category : #'creating - subelements' }
OPBoundary >> textOffset [

	^ 0 @ (4 + (self label height - self height / 2))
]

{ #category : #'as yet unclassified' }
OPBoundary >> updateAfterDragOf: draggedBox [

	self translateTo:
		(self positionOfMainRelativeToDragBoxes at: draggedBox model) value.
	self dragBoxUpdateBlocks associationsDo: [ :each | 
		each key == draggedBox model ifFalse: [ 
			self updateDragBoxBlock: each ] ].
	self pushBack
]

{ #category : #'as yet unclassified' }
OPBoundary >> updateDragBoxBlock: anAssociation [

	| dragBox |
	dragBox := dragBoxes at: anAssociation key.
	dragBox announcer
		suspendAllOf: self
		while: [ anAssociation value value: dragBox ]
]

{ #category : #'as yet unclassified' }
OPBoundary >> updateDragBoxes [

	self dragBoxUpdateBlocks associationsDo: [ :each | 
		self updateDragBoxBlock: each ].
	self pushBack
]
