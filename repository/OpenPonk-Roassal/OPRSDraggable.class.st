Class {
	#name : 'OPRSDraggable',
	#superclass : 'RSDraggable',
	#instVars : [
		'initialPosition',
		'initialAnchor'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'events' }
OPRSDraggable >> endDrag: anEvent [
	| shape hasChanged |
	shape := anEvent shape.
	hasChanged := initialPosition ~= shape position.
	hasChanged ifTrue: [
		anEvent canvas announce: (OPRSElementsDraggedEvent new
			shapes: { shape };
			initialPositions: (Dictionary with: shape -> initialPosition copy);
			initialAnchors: (initialAnchor
				ifNotNil: [ Dictionary with: shape -> initialAnchor copy ]
				ifNil: [ Dictionary new ]);
			lines: #(  );
			initialLineControlPoints: Dictionary new;
			yourself) ].
	initialPosition := nil.
	initialAnchor := nil
]

{ #category : 'hooks' }
OPRSDraggable >> onShape: aShape [
	super onShape: aShape.
	aShape
		when: RSMouseDragStart
		do: [ :event | self startDrag: event ]
		for: self.
	aShape
		when: RSMouseDragEnd
		do: [ :event | self endDrag: event ]
		for: self
]

{ #category : 'events' }
OPRSDraggable >> startDrag: anEvent [
	| draggedShape |
	draggedShape := anEvent shape.
	initialPosition := draggedShape position copy.
	initialAnchor := (draggedShape propertyAt: OPRSAnchorConstraint ifAbsent: [ nil ])
		ifNotNil: [ :anchorConstraint | anchorConstraint anchorState ]
		ifNil: [ nil ]
]
