"
Verifies value equality, coordinate conversions, and center-extent calculations in the OPNodeBounds value object.
"
Class {
	#name : 'OPNodeBoundsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'tests' }
OPNodeBoundsTest >> testBoundNodeBoundsGuardAvoidsRedundantAssignment [
	| node initialBounds identicalBounds |
	node := OPTestBoundNode new.
	initialBounds := OPNodeBounds withPosition: 50 @ 50 extent: 80 @ 40.
	node bounds: initialBounds.
	identicalBounds := OPNodeBounds withPosition: 50 @ 50 extent: 80 @ 40.
	node bounds: identicalBounds.
	self assert: node bounds identicalTo: initialBounds
]

{ #category : 'tests' }
OPNodeBoundsTest >> testEquality [
	| b1 b2 |
	b1 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	b2 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	self assert: b1 equals: b2
]

{ #category : 'tests' }
OPNodeBoundsTest >> testHash [

	| b1 b2 set |
	b1 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	b2 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	self assert: b1 hash equals: b2 hash.
	set := Set with: b1.
	self assertCollection: set includesAll: { b2 }
]

{ #category : 'tests' }
OPNodeBoundsTest >> testInequality [
	| b1 b2 b3 |
	b1 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 50.
	b2 := OPNodeBounds withPosition: 15 @ 20 extent: 100 @ 50.
	b3 := OPNodeBounds withPosition: 10 @ 20 extent: 100 @ 60.
	self deny: b1 equals: b2.
	self deny: b1 equals: b3
]

{ #category : 'tests' }
OPNodeBoundsTest >> testLegacyStonClassAliasesAndBoundsAndCameraOperations [
	| bounds camera cameraCopy roassalCanvas roassalCam style rectBounds |
	self assert: OPDIOpenPonkStyle new class identicalTo: OPOpenPonkShapeStyle.
	self assert: OPDIBounds new class identicalTo: OPNodeBounds.
	self assert: OPDICamera new class identicalTo: OPDiagramCamera.

	bounds := OPDIBounds withPosition: 10 @ 20 extent: 100 @ 50.
	camera := OPDICamera new position: 5 @ 15; scale: 1.5; yourself.
	style := OPDIOpenPonkStyle new fillColor: Color red; yourself.

	self assert: bounds class identicalTo: OPNodeBounds.
	self assert: bounds position equals: 10 @ 20.
	self assert: bounds extent equals: 100 @ 50.
	bounds translateTo: 30 @ 40.
	self assert: bounds position equals: 30 @ 40.

	rectBounds := OPNodeBounds withEncompassingRectangle: (10.4 @ 20.6 extent: 100.2 @ 50.8).
	rectBounds round.
	self assert: rectBounds origin equals: 10 @ 21.
	self assert: rectBounds extent equals: 100 @ 51.

	self assert: camera class identicalTo: OPDiagramCamera.
	self assert: camera position equals: 5 @ 15.
	self assert: camera scale equals: 1.5.
	cameraCopy := OPDiagramCamera newFrom: camera.
	self assert: camera equals: cameraCopy.
	self assert: camera hash equals: cameraCopy hash.
	self deny: (camera = 'not-a-camera') description: 'Camera should not equal an object of another class'.
	roassalCanvas := RSCanvas new.
	roassalCam := roassalCanvas camera.
	camera updateRoassalCamera: roassalCam.
	self assert: roassalCam scale equals: 1.5.
	self assert: roassalCam position equals: 5 @ 15.

	self assert: style class identicalTo: OPOpenPonkShapeStyle.
	self assert: style fillColor equals: Color red.
	self assert: OPDIOpenPonkStyle isDeprecated description: 'OPDIOpenPonkStyle should be marked deprecated'.
	self assert: OPDIBounds isDeprecated description: 'OPDIBounds should be marked deprecated'.
	self assert: OPDICamera isDeprecated description: 'OPDICamera should be marked deprecated'
]
