"
Verifies Kernel, Geometry, and Roassal extension methods defined in OpenPonk-Roassal.
"
Class {
	#name : 'OPRSExtensionsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Extensions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Extensions'
}

{ #category : 'tests' }
OPRSExtensionsTest >> testCanvasAndShapeEventLookupAndIgnoredElements [

	| canvas boxA boxB |
	canvas := RSCanvas new.
	self deny: canvas isSelectable description: 'RSCanvas itself must report isSelectable = false'.

	boxA := RSBox new
		        extent: 40 @ 40;
		        translateTo: 0 @ 0;
		        yourself.
	boxB := RSBox new
		        extent: 40 @ 40;
		        translateTo: 0 @ 0;
		        yourself.
	boxA when: RSMouseClick do: [ :event |  ] for: self.
	canvas
		add: boxA;
		add: boxB.

	self assertCollection: (canvas shapesWithActionForPosition: 0 @ 0) hasSameElements: { boxA }.
	self assert: (boxA shapeWithActionForPosition: 0 @ 0) identicalTo: boxA.
	self assert: (boxA shapeWithActionForPosition: 100 @ 100) identicalTo: nil.
	self assert: (boxB shapeWithActionForPosition: 0 @ 0) identicalTo: nil.

	canvas propertyAt: #ignoredElementsForEvents put: (Set with: boxA).
	self assertEmpty: (canvas shapesWithActionForPosition: 0 @ 0).
	self assert: (boxA shapeWithActionForPosition: 0 @ 0) identicalTo: nil
]

{ #category : 'tests' }
OPRSExtensionsTest >> testCloseToAbsolutePrecisionOnFloatNumberAndPoint [

	| erroringObject |
	erroringObject := Object new.
	self
		assert: (0.0 closeTo: 0.05 absolutePrecision: 0.1)
		description: 'Zero float should be close to small number within precision'.
	self deny: (0.0 closeTo: 0.2 absolutePrecision: 0.1) description: 'Zero float should not be close to value outside precision'.
	self assert: (0.05 closeTo: 0 absolutePrecision: 0.1) description: 'Small float should be close to zero within precision'.
	self deny: (0.2 closeTo: 0 absolutePrecision: 0.1) description: 'Larger float should not be close to zero outside precision'.
	self deny: (1.5 closeTo: 'not-a-number' absolutePrecision: 0.1) description: 'Float should not be close to a non-number'.
	self
		assert: (1 closeTo: 1.05 absolutePrecision: 0.1)
		description: 'Integer should delegate closeTo:absolutePrecision: when compared with Float'.
	self
		deny: (1 closeTo: erroringObject absolutePrecision: 0.1)
		description: 'Number should return false when subtraction on non-number raises an error'.
	self
		assert: (10 @ 20 closeTo: 10.05 @ 19.95 absolutePrecision: 0.1)
		description: 'Points within precision on both axes should be close'.
	self
		deny: (10 @ 20 closeTo: 10.05 @ 20.5 absolutePrecision: 0.1)
		description: 'Points outside precision on Y axis should not be close'
]

{ #category : 'tests' }
OPRSExtensionsTest >> testControlConfigurationAndCorrectRectangleCamera [

	| config interaction canvas rectangle corrected |
	config := RSControlConfiguration new.
	self assert: config keepCameraOnContent description: 'Default RSControlConfiguration should keep camera on content'.

	canvas := RSCanvas new.
	canvas extent: 200 @ 200.
	rectangle := 0 @ 0 extent: 50 @ 50.

	interaction := RSDraggableCanvasInteraction new.
	interaction configuration: (OPRSControlConfiguration new
			 keepCameraOnContent: false;
			 yourself).
	self assert: (interaction correctRectangle: rectangle camera: canvas camera) equals: rectangle.

	interaction configuration keepCameraOnContent: true.
	corrected := interaction correctRectangle: rectangle camera: canvas camera.
	self assert: corrected extent equals: rectangle extent
]

{ #category : 'tests' }
OPRSExtensionsTest >> testDeepShapesCompositeTextGroupAndShapeUtilities [

	| canvas childLabelA childLabelB innerBox composite group detachedBox borderedBox emptyMarker |
	canvas := RSCanvas new.
	childLabelA := RSLabel new
		               text: 'First';
		               yourself.
	childLabelB := RSLabel new
		               text: 'Second';
		               yourself.
	innerBox := RSBox new
		            extent: 20 @ 10;
		            yourself.
	composite := RSComposite new.
	self assert: composite text equals: ''.
	composite
		add: innerBox;
		add: childLabelA;
		add: childLabelB.
	self assert: composite text equals: (String cr join: #( 'First' 'Second' )).

	canvas add: composite.
	self assertCollection: canvas deepShapes includesAll: {
			composite.
			innerBox.
			childLabelA.
			childLabelB }.

	group := RSGroup
		         with: (RSBox new
				          size: 10;
				          yourself)
		         with: (RSBox new
				          size: 10;
				          yourself).
	self deny: group isInACanvas description: 'Detached RSGroup should not report being in a canvas'.
	canvas addAll: group.
	self assert: group isInACanvas description: 'RSGroup with shapes added to canvas should report isInACanvas = true'.
	group remove.
	self deny: group isInACanvas description: 'RSGroup>>#remove must remove all member shapes from canvas'.

	detachedBox := RSBox new
		               extent: 20 @ 10;
		               border: nil;
		               yourself.
	self assert: detachedBox extentWithoutBorder equals: 20 @ 10.
	self deny: detachedBox isSelected description: 'Shape without a canvas must report isSelected = false'.

	borderedBox := RSBox new
		               extent: 20 @ 10;
		               borderWidth: 2;
		               yourself.
	self assert: borderedBox extentWithoutBorder equals: borderedBox extent - 2.

	emptyMarker := detachedBox asEmptyMarker.
	self assert: emptyMarker class equals: OPRSEmptyMarker
]
