Class {
	#name : #OPRSSelectionDraggableBorder,
	#superclass : #OPRSSelectionDraggable,
	#instVars : [
		'shape',
		'dragBoxes',
		'dragBoxUpdateBlocks',
		'positionOfMainRelativeToDragBoxes',
		'dragBoxWidth'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #hooks }
OPRSSelectionDraggableBorder >> createDragBoxes [

	| horizonalBoxShape verticalBoxShape forwardEvent renderDragBoxes |
	horizonalBoxShape := RSBox new
		                     color: Color transparent;
		                     borderColor: Color transparent;
		                     width: shape width + self dragBoxWidth;
		                     height: self dragBoxWidth;
		                     yourself.
	verticalBoxShape := horizonalBoxShape copy
		                    width: self dragBoxWidth;
		                    height:
			                    (shape height - self dragBoxWidth max: 0 @ 0);
		                    yourself.
	dragBoxes := { 
		             (#top -> horizonalBoxShape).
		             (#bottom -> horizonalBoxShape copy).
		             (#left -> verticalBoxShape).
		             (#right -> verticalBoxShape copy) } asDictionary.
	dragBoxes associationsDo: [ :each | each value model: shape ].
	renderDragBoxes := [ shape canvas addAll: dragBoxes ].
	shape isInACanvas
		ifTrue: renderDragBoxes
		ifFalse: [ shape when: RSShapeAddedEvent do: renderDragBoxes ].
	shape when: RSShapeRemovedEvent do: [ dragBoxes do: #remove ].
	forwardEvent := [ :event | shape announce: event copy ].
	dragBoxes do: [ :each | 
		each
			when: RSMouseDragStart do: [ :event | self startDrag: shape ];
			when: RSMouseDragging do: [ :event | 
				self processDrag: (event copy
							 shape: shape;
							 yourself) ].
		each
			when: RSMouseDragStart do: forwardEvent;
			when: RSMouseDragEnd do: forwardEvent;
			when: RSMouseClick do: forwardEvent ].
	shape
		when: RSExtentChangedEvent do: [ self updateDragBoxes ];
		when: RSPositionChangedEvent do: [ self updateDragBoxes ]
]

{ #category : #hooks }
OPRSSelectionDraggableBorder >> dragBoxUpdateBlocks [

	^ dragBoxUpdateBlocks ifNil: [ 
		  dragBoxUpdateBlocks := { 
			                         (#top -> [ :dragBox | 
			                          dragBox
				                          width: shape width + self dragBoxWidth;
				                          translateTo:
					                          shape encompassingRectangle topCenter ]).
			                         (#bottom -> [ :dragBox | 
			                          dragBox
				                          width: shape width + self dragBoxWidth;
				                          translateTo:
					                          shape encompassingRectangle
						                          bottomCenter ]).
			                         (#left -> [ :dragBox | 
			                          dragBox
				                          height:
					                          (shape height - self dragBoxWidth max:
							                           0);
				                          translateTo:
					                          shape encompassingRectangle leftCenter ]).
			                         (#right -> [ :dragBox | 
			                          dragBox
				                          height:
					                          (shape height - self dragBoxWidth max:
							                           0);
				                          translateTo:
					                          shape encompassingRectangle rightCenter ]) }
			                         asDictionary ]
]

{ #category : #accessing }
OPRSSelectionDraggableBorder >> dragBoxWidth [

	^ dragBoxWidth
]

{ #category : #accessing }
OPRSSelectionDraggableBorder >> dragBoxWidth: aNumber [

	"Thickness of dragboxes. Has no effect once applied on shape"

	dragBoxWidth := aNumber
]

{ #category : #initialization }
OPRSSelectionDraggableBorder >> initialize [

	super initialize.
	dragBoxWidth := 10
]

{ #category : #hooks }
OPRSSelectionDraggableBorder >> onShape: aShape [

	shape := aShape.
	self checkChildrenActions: aShape.
	shape propertyAt: self propertyKey put: self.
	self createDragBoxes
]

{ #category : #hooks }
OPRSSelectionDraggableBorder >> positionOfMainRelativeToDragBoxes [

	^ positionOfMainRelativeToDragBoxes ifNil: [ 
		  positionOfMainRelativeToDragBoxes := { 
			                                       (#top
			                                        -> [ 
			                                        (dragBoxes at: #top)
				                                        position
			                                        + (0 @ (shape height / 2)) ]).
			                                       (#bottom
			                                        -> [ 
			                                        (dragBoxes at: #bottom)
				                                        position
			                                        - (0 @ (shape height / 2)) ]).
			                                       (#left
			                                        -> [ 
			                                        (dragBoxes at: #left)
				                                        position
			                                        + (shape width / 2 @ 0) ]).
			                                       (#right
			                                        -> [ 
			                                        (dragBoxes at: #right)
				                                        position
			                                        - (shape width / 2 @ 0) ]) }
			                                       asDictionary ]
]

{ #category : #hooks }
OPRSSelectionDraggableBorder >> updateDragBoxBlock: anAssociation [

	anAssociation value value: (dragBoxes at: anAssociation key)
]

{ #category : #hooks }
OPRSSelectionDraggableBorder >> updateDragBoxes [

	self dragBoxUpdateBlocks associationsDo: [ :each | 
		self updateDragBoxBlock: each ].
	shape pushBack
]
