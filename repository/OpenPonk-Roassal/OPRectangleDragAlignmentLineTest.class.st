Class {
	#name : 'OPRectangleDragAlignmentLineTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPRectangleDragAlignmentLineTest >> testHorizontalAlignmentLineCalculations [
	| line verticalLine |
	line := OPRectangleDragAlignmentHorizontalLine
		dragged: 10 @ 18
		compared: 100 @ 20.
	self assert: line dragged equals: 10 @ 18.
	self assert: line compared equals: 100 @ 20.
	self assert: line adaptation2dOffset equals: 2.
	self assert: line adaptationDistance equals: 2.
	self assert: line adaptationOffset equals: 0 @ 2.
	self assert: line draggedAdapted equals: 10 @ 20.
	self assert: line resultingDistance equals: 90.
	self assert: line normalized equals: 0.0 @ -1.0.
	verticalLine := OPRectangleDragAlignmentVerticalLine
		dragged: 15 @ 10
		compared: 20 @ 80.
	line includeOffsetOf: verticalLine.
	self assert: line dragged equals: 15 @ 18
]

{ #category : 'tests' }
OPRectangleDragAlignmentLineTest >> testRectangleAlignmentLinesSelection [
	| draggedRect targetRect horizLines vertLines |
	draggedRect := 10 @ 19 corner: 50 @ 65.
	targetRect := 100 @ 20 corner: 140 @ 60.
	self assert: draggedRect floatCenterX closeTo: 30.0.
	self assert: draggedRect floatCenterY closeTo: 42.0.
	horizLines := draggedRect horizontalAlignmentLinesTo: targetRect margin: 5.
	self assert: horizLines size equals: 1.
	self assert: horizLines first adaptationDistance closeTo: 1.0.
	self assert: horizLines first dragged equals: 10 @ 19.
	vertLines := (19 @ 10 corner: 65 @ 50)
		verticalAlignmentLinesTo: (20 @ 100 corner: 60 @ 140)
		margin: 5.
	self assert: vertLines size equals: 1.
	self assert: vertLines first adaptationDistance closeTo: 1.0.
	self assert: vertLines first dragged equals: 19 @ 10
]

{ #category : 'tests' }
OPRectangleDragAlignmentLineTest >> testVerticalAlignmentLineCalculations [
	| line |
	line := OPRectangleDragAlignmentVerticalLine
		draggedFirst: 18 @ 10
		draggedSecond: 18 @ 50
		comparedFirst: 20 @ 100
		comparedSecond: 20 @ 160.
	self assert: line dragged equals: 18 @ 10.
	self assert: line compared equals: 20 @ 160.
	self assert: line adaptation2dOffset equals: 2.
	self assert: line adaptationDistance equals: 2.
	self assert: line adaptationOffset equals: 2 @ 0.
	self assert: line draggedAdapted equals: 20 @ 10.
	self assert: line resultingDistance equals: 150.
	self assert: line normalized equals: -1.0 @ 0.0
]
