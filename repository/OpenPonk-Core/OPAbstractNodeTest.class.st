Class {
	#name : 'OPAbstractNodeTest',
	#superclass : 'OPAbstractDiagramElementTest',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPAbstractNodeTest >> testDoesNotMoveOnShapeCreation [

	| diagram originalRoassalPosition movedRoassalPosition newShape |
	diagram := OPOpenPonkDiagram new.
	diagram renderIn: canvas.
	shape owningElement: diagram.
	shape modelElement: model.
	shape renderIn: canvas.
	shape isPositionableByUser ifFalse: [ ^ self ].
	originalRoassalPosition := shape roassalShape position.
	shape updateFromRender.
	self assert: shape bounds position equals: originalRoassalPosition.
	shape roassalShape translateBy: 100 @ 50.
	movedRoassalPosition := shape roassalShape position.
	self
		assert: movedRoassalPosition
		equals: originalRoassalPosition + (100 @ 50).
	self assert: shape bounds position equals: originalRoassalPosition.
	newShape := OPTestLabel in: diagram.
	newShape renderIn: canvas.
	self assert: shape bounds position equals: originalRoassalPosition.
	self assert: shape roassalShape position equals: movedRoassalPosition
]

{ #category : 'tests' }
OPAbstractNodeTest >> testUpdateFromRender [

	| originalBounds movedBounds |
	self assert: shape bounds equals: nil.
	shape modelElement: model.
	shape renderIn: canvas.
	shape updateFromRender.
	shape isPositionableByUser ifFalse: [ ^ self ].
	originalBounds := shape bounds veryDeepCopy.
	shape roassalShape translateBy: 100 @ 50.
	self assert: shape bounds position equals: originalBounds position.
	shape updateFromRender.
	movedBounds := shape bounds veryDeepCopy.
	self deny: movedBounds position equals: originalBounds position.
	self assert: movedBounds position equals: originalBounds position + (100 @ 50).
	
]
