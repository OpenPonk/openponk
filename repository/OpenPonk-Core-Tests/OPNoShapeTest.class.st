"
Verifies the Null-Object behavior and singleton lifecycle of OPNoShape.
"
Class {
	#name : 'OPNoShapeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'tests' }
OPNoShapeTest >> testNullObjectBehaviorAndExistenceConditions [
	| noShape |
	OPNoShape reset.
	noShape := OPNoShape new.
	self assert: noShape identicalTo: OPNoShape instance.
	self
		assert: noShape isNoShape
		description: 'OPNoShape should answer true to isNoShape'.
	self
		assert: noShape doesNotExist
		description: 'OPNoShape should answer true to doesNotExist'.
	self
		deny: noShape exists
		description: 'OPNoShape should answer false to exists'.
	self
		deny: noShape isNode
		description: 'OPNoShape should not be reported as a node'.
	self
		deny: noShape isEdge
		description: 'OPNoShape should not be reported as an edge'.
	self
		deny: noShape isRendered
		description: 'OPNoShape should never be reported as rendered'.
	self assert: noShape modelElement equals: nil.
	self assert: noShape roassalShape equals: nil.
	self assert: noShape sharedStyle equals: nil.
	self assert: noShape owningElementWithPossibleController identicalTo: noShape.
	self assert: noShape orOwningElementWithPossibleController identicalTo: noShape.
	self assertEmpty: noShape ownedElements.
	self assertEmpty: noShape sourceEdges.
	self assertEmpty: noShape targetEdges.
	self assert: (noShape ifExists: [ #found ]) equals: nil.
	self assert: (noShape ifExists: [ #found ] else: [ #missing ]) equals: #missing.
	self assert: (noShape ifNotExists: [ #missing ]) equals: #missing.
	self assert: (noShape readSlotNamed: #any) equals: nil.
	self assert: (noShape writeSlotNamed: #any value: 42) equals: nil.
	noShape
		modelChanged;
		remove;
		removeRender;
		unsubscribe: self;
		roassalShapeUnsubscribe: self;
		ownedElement: nil willRenderIn: nil;
		ownedElement: nil renderedIn: nil;
		recursivelyOwnedElement: nil renderedIn: nil;
		ownedElementRemovedRender: nil
]
