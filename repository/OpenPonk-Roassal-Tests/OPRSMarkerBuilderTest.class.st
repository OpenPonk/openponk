"
Verifies marker creation in OPRSMarkerBuilder, OPRSEmptyMarkerBuilder, and color propagation in OPRSBorderColoringComposite.
"
Class {
	#name : 'OPRSMarkerBuilderTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Markers',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Markers'
}

{ #category : 'tests' }
OPRSMarkerBuilderTest >> testBorderColoringCompositeNilColorAndPaintAndEmptyShapeProxy [

	| composite box proxy underlyingShape |
	box := RSBox new
		       size: 10;
		       color: Color yellow;
		       yourself.
	composite := OPRSBorderColoringComposite new.
	composite add: box.
	composite paint: Color green.
	self assert: box paint equals: Color green.
	composite color: nil.
	self assert: composite paint identicalTo: nil.
	composite paint: nil.
	self assert: composite paint identicalTo: nil.

	underlyingShape := RSBox new
		                   size: 12;
		                   borderColor: Color black;
		                   yourself.
	proxy := OPRSEmptyShapeProxy new
		         shape: underlyingShape;
		         yourself.
	proxy color: Color red.
	self assert: underlyingShape borderColor equals: Color red.
	proxy paint: Color blue.
	self assert: underlyingShape borderColor equals: Color blue.
	proxy paint: nil.
	self assert: underlyingShape borderColor equals: Color blue.
	self assert: proxy borderColor equals: Color blue.
	self assert: proxy extent equals: underlyingShape extent
]

{ #category : 'tests' }
OPRSMarkerBuilderTest >> testBorderColoringCompositeRemoveShapeUpdatesCompositeAndAnnouncesConsistentState [

	| composite box label eventReceived seenInBorderColorDuringEvent seenInShapesDuringEvent |
	box := RSBox new
		       size: 10;
		       yourself.
	label := RSLabel new
		         text: 'X';
		         yourself.
	composite := OPRSBorderColoringComposite new.
	composite add: box.
	composite useBorderColorAsPaintFor: label.

	eventReceived := false.
	seenInBorderColorDuringEvent := true.
	seenInShapesDuringEvent := true.
	composite
		when: RSShapeRemovedEvent
		do: [ :event |
				eventReceived := true.
				seenInBorderColorDuringEvent := composite shapesToUseBorderColor includes: event shape.
				seenInShapesDuringEvent := composite shapes includes: event shape ]
		for: self.

	composite removeShape: label.
	self assertEmpty: composite shapesToUseBorderColor.
	self assertCollection: composite shapes hasSameElements: { box }.
	self assertCollection: composite shapesToUsePaint hasSameElements: { box }.
	self assert: label parent identicalTo: nil.
	self assert: eventReceived description: 'Removing a shape from OPRSBorderColoringComposite must announce RSShapeRemovedEvent'.
	self
		deny: seenInBorderColorDuringEvent
		description: 'Removed shape must already be absent from shapesToUseBorderColor when RSShapeRemovedEvent fires'.
	self deny: seenInShapesDuringEvent description: 'Removed shape must already be absent from shapes when RSShapeRemovedEvent fires'.

	composite removeShape: box.
	self assertEmpty: composite shapes.
	self assertEmpty: composite shapesToUsePaint.
	self assert: box parent identicalTo: nil
]

{ #category : 'tests' }
OPRSMarkerBuilderTest >> testEmptyMarkersAndBorderColoringComposite [

	| emptyArrow composite box label |
	emptyArrow := OPRSEmptyMarkerBuilder arrow.
	self assert: emptyArrow class equals: OPRSEmptyMarker.
	self assert: emptyArrow asEmptyMarker identicalTo: emptyArrow.
	self assert: emptyArrow shape class equals: OPRSEmptyShapeProxy.
	box := RSBox new
		       size: 10;
		       yourself.
	label := RSLabel new
		         text: 'X';
		         yourself.
	composite := OPRSBorderColoringComposite new.
	composite add: box.
	composite useBorderColorAsPaintFor: label.
	self assertCollection: composite shapesToUseBorderColor hasSameElements: { label }.
	self assertCollection: composite shapesToUsePaint hasSameElements: { box }.
	composite color: Color yellow.
	self assert: box color equals: Color yellow.
	composite borderColor: Color blue.
	self assert: box borderColor equals: Color blue.
	self assert: label color equals: Color blue.
	composite keepPaintTransparencyFromBorder.
	composite borderColor: Color transparent.
	self assert: label color equals: Color transparent.
	composite noPaint.
	self assert: box paint identicalTo: nil.
	composite removeShape: label.
	self assertEmpty: composite shapesToUseBorderColor
]

{ #category : 'tests' }
OPRSMarkerBuilderTest >> testStandardMarkersCreation [
	| arrow circle diamond triangle doubleTriangle letterDiamond |
	arrow := OPRSMarkerBuilder arrow.
	circle := OPRSMarkerBuilder circle.
	diamond := OPRSMarkerBuilder diamond.
	triangle := OPRSMarkerBuilder triangle.
	doubleTriangle := OPRSMarkerBuilder doubleTriangle.
	letterDiamond := OPRSMarkerBuilder diamondWithLetter: $A.
	self assert: arrow class equals: RSMarker.
	self assert: arrow offset equals: 5.
	self assert: circle shape class equals: RSCircle.
	self assert: diamond shape class equals: RSPolygon.
	self assert: triangle shape class equals: RSPolygon.
	self assert: doubleTriangle shape class equals: RSPolygon.
	self assert: letterDiamond shape class equals: OPRSBorderColoringComposite
]
