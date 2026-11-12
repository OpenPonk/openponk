"
Specialized draggable interaction used for visual boundaries. 
Maintains and updates invisible drag boxes (handles) around the boundary to facilitate unified resizing and movement.
"
Class {
	#name : 'OPRSSelectionDraggableBorder',
	#superclass : 'OPRSSelectionDraggable',
	#instVars : [
		'shape',
		'dragBoxes',
		'dragBoxUpdateBlocks'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'private' }
OPRSSelectionDraggableBorder >> attachDragBoxesToShape [

	shape isInACanvas
		ifTrue: [ shape canvas addAll: dragBoxes ]
		ifFalse: [
			shape
				when: RSShapeAddedEvent
				do: [ shape canvas addAll: dragBoxes ]
				for: self ].
	shape
		when: RSShapeRemovedEvent
		do: [ dragBoxes do: #remove ]
		for: self
]

{ #category : 'private' }
OPRSSelectionDraggableBorder >> createDragBoxes [

	| horizontalBoxShape verticalBoxShape |
	horizontalBoxShape := RSBox new
		color: Color transparent;
		width: shape width + self dragBoxWidth;
		height: self dragBoxWidth;
		yourself.
	verticalBoxShape := horizontalBoxShape copy
		width: self dragBoxWidth;
		height: (shape height - self dragBoxWidth max: 0);
		yourself.
	dragBoxes := {
		(#top -> horizontalBoxShape).
		(#bottom -> horizontalBoxShape copy).
		(#left -> verticalBoxShape).
		(#right -> verticalBoxShape copy) } asDictionary.
	dragBoxes associationsDo: [ :each | each value model: shape model ].
	self attachDragBoxesToShape.
	self registerDragBoxEvents
]

{ #category : 'hooks' }
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

{ #category : 'accessing' }
OPRSSelectionDraggableBorder >> dragBoxWidth [

	^ 12
]

{ #category : 'private' }
OPRSSelectionDraggableBorder >> forwardEventToShape: anEvent [

	| eventForMainShape |
	eventForMainShape := anEvent copy.
	shape announce: eventForMainShape.
	^ eventForMainShape
]

{ #category : 'hooks' }
OPRSSelectionDraggableBorder >> onShape: aShape [

	shape := aShape.
	self checkChildrenActions: aShape.
	shape propertyAt: self propertyKey put: self.
	self createDragBoxes
]

{ #category : 'private' }
OPRSSelectionDraggableBorder >> registerDragBoxEvents [

	dragBoxes do: [ :each |
		each
			when: RSMouseDragStart
			do: [ :event | self startDrag: (self forwardEventToShape: event) ]
			for: self;
			when: RSMouseDragging
			do: [ :event | self processDrag: (self forwardEventToShape: event) ]
			for: self;
			when: RSMouseDragEnd
			do: [ :event | self endDrag: (self forwardEventToShape: event) ]
			for: self;
			when: RSMouseClick
			do: [ :event | self forwardEventToShape: event ]
			for: self ].
	shape
		when: RSExtentChangedEvent do: [ self updateDragBoxes ] for: self;
		when: RSPositionChangedEvent do: [ self updateDragBoxes ] for: self
]

{ #category : 'hooks' }
OPRSSelectionDraggableBorder >> updateDragBoxBlock: anAssociation [

	anAssociation value value: (dragBoxes at: anAssociation key)
]

{ #category : 'hooks' }
OPRSSelectionDraggableBorder >> updateDragBoxes [

	self dragBoxUpdateBlocks associationsDo: [ :each |
		self updateDragBoxBlock: each ].
	shape pushBack
]
