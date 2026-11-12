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
OPRSMarkerBuilderTest >> testEmptyMarkersAndBorderColoringComposite [
	| emptyArrow composite box label |
	emptyArrow := OPRSEmptyMarkerBuilder arrow.
	self assert: emptyArrow class equals: OPRSEmptyMarker.
	self assert: emptyArrow asEmptyMarker identicalTo: emptyArrow.
	self assert: emptyArrow shape class equals: OPRSEmptyShapeProxy.
	box := RSBox new size: 10; yourself.
	label := RSLabel new text: 'X'; yourself.
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
	self assert: box paint equals: nil.
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
