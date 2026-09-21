"
Reversible command recording and applying dimension and position changes to an OPBoundNode. Guards against reference aliasing by defensively copying OPNodeBounds instances during construction, execution, and rollback.
"
Class {
	#name : 'OPChangeBoundsCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'element',
		'oldBounds',
		'newBounds'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPChangeBoundsCommand class >> element: aDiagramElement oldBounds: anOldBounds newBounds: aNewBounds [
	^ self new
		element: aDiagramElement
		oldBounds: anOldBounds
		newBounds: aNewBounds;
		yourself
]

{ #category : 'accessing' }
OPChangeBoundsCommand >> element [
	^ element
]

{ #category : 'accessing' }
OPChangeBoundsCommand >> element: aDiagramElement oldBounds: anOldBounds newBounds: aNewBounds [
	element := aDiagramElement.
	oldBounds := anOldBounds copy.
	newBounds := aNewBounds copy
]

{ #category : 'executing' }
OPChangeBoundsCommand >> execute [
	element bounds: newBounds copy.
	element updateRenderFromSelf
]

{ #category : 'accessing' }
OPChangeBoundsCommand >> newBounds [
	^ newBounds
]

{ #category : 'accessing' }
OPChangeBoundsCommand >> oldBounds [
	^ oldBounds
]

{ #category : 'executing' }
OPChangeBoundsCommand >> undo [
	element bounds: oldBounds copy.
	element updateRenderFromSelf
]
