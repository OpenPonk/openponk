"
Unit tests for OPLabel. 
Verifies the default behaviors, properties, and constraints of basic text labels on the canvas.
"
Class {
	#name : 'OPLabelTest',
	#superclass : 'OPAbstractLabelTest',
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'instance creation' }
OPLabelTest >> modelClass [

	^ Mock
]

{ #category : 'tests' }
OPLabelTest >> testEdgeLabelRenderingAndAnchorSynchronization [
	| canvas sourceNode targetNode edge edgeLabel style |
	canvas := RSCanvas new.
	sourceNode := OPTestBoundNode new
		bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 50 @ 50);
		renderIn: canvas;
		yourself.
	targetNode := OPTestBoundNode new
		bounds: (OPNodeBounds withPosition: 200 @ 0 extent: 50 @ 50);
		renderIn: canvas;
		yourself.
	edge := OPTestEdge new
		source: sourceNode;
		target: targetNode;
		renderIn: canvas;
		yourself.

	edgeLabel := OPTestEdgeLabel in: edge.
	self should: [ OPEdgeLabel new defaultMinDistance ] raise: SubclassResponsibility.
	self should: [ OPEdgeLabel new defaultAnchorConstraintPosition ] raise: SubclassResponsibility.

	edgeLabel updateRenderFromSelf.
	self deny: edgeLabel isRendered description: 'Unrendered edge label should ignore updateRenderFromSelf'.

	edgeLabel renderIn: canvas.
	self assert: edgeLabel isRendered description: 'Edge label should be rendered in canvas'.
	self assert: edgeLabel roassalShape text equals: 'edge-label'.
	self
		deny: (edgeLabel roassalShape propertyAt: OPRSAnchorConstraint)
		identicalTo: nil.

	edgeLabel roassalShape translateTo: 100 @ 20.
	edgeLabel updateFromRender.
	self assert: edgeLabel bounds position equals: 100 @ 20.

	edgeLabel updateRenderFromSelf.
	edgeLabel updateRenderFromModel.
	self assert: edgeLabel roassalShape text equals: 'edge-label'.

	style := OPOpenPonkShapeStyle new.
	style fontBold: true; fontItalic: true; fontStrikeThrough: true; fontUnderline: true; fontSize: 14; fontColor: Color red.
	edgeLabel localStyle: style.
	edgeLabel updateRenderFromStyles.
	self assert: edgeLabel fontSize equals: 14.
	self assert: edgeLabel fontColor equals: Color red.
	edgeLabel noText.
	self assert: edgeLabel text equals: ''.
	edgeLabel resetText.
	self assert: edgeLabel text equals: 'edge-label'
]
