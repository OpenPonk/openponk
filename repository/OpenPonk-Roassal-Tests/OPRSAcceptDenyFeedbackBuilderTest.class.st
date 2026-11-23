"
Verifies accept and deny visual feedback creation and cleanup for canvas, line, node, and invalid targets.
"
Class {
	#name : 'OPRSAcceptDenyFeedbackBuilderTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-CreationFeedback',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'CreationFeedback'
}

{ #category : 'tests' }
OPRSAcceptDenyFeedbackBuilderTest >> testInvalidTargetRaisesErrorAndCanvasReturnsCanvasFeedback [

	| canvas canvasFeedback |
	self should: [ OPRSAcceptDenyFeedbackBuilder acceptFeedbackFor: Object new ] raise: Error.

	canvas := RSCanvas new.
	canvasFeedback := OPRSAcceptDenyFeedbackBuilder acceptFeedbackFor: canvas.
	self assert: canvasFeedback class equals: OPRSCanvasADFeedback.
	canvasFeedback remove.
	self assertEmpty: canvas shapes
]

{ #category : 'tests' }
OPRSAcceptDenyFeedbackBuilderTest >> testLineFeedbackChangesRestoresAndIsIdempotent [

	| canvas source target line firstFeedback secondFeedback |
	canvas := RSCanvas new.
	source := RSBox new
		          size: 20;
		          translateTo: 0 @ 0;
		          yourself.
	target := RSBox new
		          size: 20;
		          translateTo: 100 @ 0;
		          yourself.
	line := RSLine new
		        from: source;
		        to: target;
		        color: Color black;
		        yourself.
	canvas
		add: source;
		add: target;
		add: line.

	firstFeedback := OPRSAcceptDenyFeedbackBuilder acceptFeedbackFor: line.
	self assert: firstFeedback class equals: OPRSLineADFeedback.
	self assert: line color equals: Color green.
	self assert: (line propertyAt: firstFeedback originalColorSymbol) equals: Color black.

	secondFeedback := OPRSAcceptDenyFeedbackBuilder denyFeedbackFor: line.
	self assert: line color equals: Color green.
	self assert: (line propertyAt: firstFeedback originalColorSymbol) equals: Color black.

	firstFeedback remove.
	self assert: line color equals: Color black.
	self
		deny: (line hasProperty: firstFeedback originalColorSymbol)
		description: 'Removing line feedback must clean up stored original color property'.

	firstFeedback remove.
	secondFeedback remove.
	self assert: line color equals: Color black
]

{ #category : 'tests' }
OPRSAcceptDenyFeedbackBuilderTest >> testNodeFeedbackSupportsBoxEllipseNonNodeAndIdempotentRemove [

	| canvas box boxFeedback ellipse ellipseFeedback nonNodeFeedback |
	canvas := RSCanvas new.
	box := RSBox new
		       extent: 40 @ 20;
		       cornerRadius: 6;
		       translateTo: 50 @ 50;
		       yourself.
	ellipse := RSEllipse new
		           extent: 30 @ 30;
		           translateTo: 150 @ 50;
		           yourself.
	canvas
		add: box;
		add: ellipse.

	boxFeedback := OPRSAcceptDenyFeedbackBuilder acceptFeedbackFor: box.
	self assert: boxFeedback class equals: OPRSNodeADFeedback.
	self assert: boxFeedback feedback class equals: RSBox.
	self assert: boxFeedback feedback cornerRadius equals: box cornerRadius.
	self assert: boxFeedback feedback extent equals: box extent + (3 @ 3).
	self assert: canvas shapes size equals: 3.
	boxFeedback remove.
	self assert: canvas shapes size equals: 2.
	boxFeedback remove.
	self assert: canvas shapes size equals: 2.

	ellipseFeedback := OPRSAcceptDenyFeedbackBuilder denyFeedbackFor: ellipse.
	self assert: ellipseFeedback feedback class equals: RSEllipse.
	self assert: canvas shapes size equals: 3.
	ellipseFeedback remove.
	self assert: canvas shapes size equals: 2.

	nonNodeFeedback := OPRSNodeADFeedback new
		                   feedbackFor: RSLine new color: Color green;
		                   yourself.
	self assert: nonNodeFeedback feedback identicalTo: nil.
	nonNodeFeedback remove
]
