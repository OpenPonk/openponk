Class {
	#name : 'OPNodeBoundsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'as yet unclassified' }
OPNodeBoundsTest >> testBoundNodeBoundsGuardAvoidsRedundantAssignment [
	| node initialBounds identicalBounds |
	node := OPTestBoundNode new.
	initialBounds := OPNodeBounds withPosition: 50 @ 50 extent: 80 @ 40.
	node bounds: initialBounds.
	identicalBounds := OPNodeBounds withPosition: 50 @ 50 extent: 80 @ 40.
	node bounds: identicalBounds.
	self assert: node bounds identicalTo: initialBounds
]

{ #category : 'as yet unclassified' }
OPNodeBoundsTest >> testEquality [
	| b1 b2 |
	b1 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	b2 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	self assert: b1 equals: b2
]

{ #category : 'as yet unclassified' }
OPNodeBoundsTest >> testHash [
	| b1 b2 set |
	b1 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	b2 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	self assert: b1 hash equals: b2 hash.
	set := Set with: b1.
	self assert: (set includes: b2)
]

{ #category : 'as yet unclassified' }
OPNodeBoundsTest >> testInequality [
	| b1 b2 b3 |
	b1 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	b2 := OPNodeBounds withPosition: 15 @ 20 extent: 100 @ 50.
	b3 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 60.
	self deny: b1 equals: b2.
	self deny: b1 equals: b3
]
