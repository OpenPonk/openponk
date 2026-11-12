Class {
	#name : 'OPDiagramTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'tests' }
OPDiagramTest >> testDiagramPropertiesRenderingAndPluginResolution [
	| model diagram canvas otherCanvas childNode customSheet |
	model := OPTestContainerModel new name: 'ContainerModel'; yourself.
	diagram := OPDiagram forModelElement: model.

	self assert: diagram name equals: 'ContainerModel'.
	diagram name: 'CustomDiagramName'.
	self assert: diagram name equals: 'CustomDiagramName'.
	self assert: diagram modelElementType equals: 'OPTestContainerModel'.
	self
		deny: diagram shouldBePositionableByUser
		description: 'OPDiagram must not be positionable by user'.
	self assert: diagram renderBasicShape equals: nil.
	self assert: diagram renderShapeDetails equals: nil.
	self
		assertCollection: OPDiagram stonAllInstVarNames
		includesAll: #( #name ).

	[
		OPPluginRegistry setDefault: OPPluginRegistry new.
		self assert: diagram findPlugin equals: nil.
		self assert: diagram defaultStyleSheet class identicalTo: OPStyleSheet.

		OPPluginRegistry default add: OPTestPlugin new.
		self assert: diagram findPlugin class identicalTo: OPTestPlugin.
		self assert: diagram defaultStyleSheet class identicalTo: OPStyleSheet.

		OPPluginRegistry default add: OPTestSecondaryPlugin new.
		self assert: diagram findPlugin class identicalTo: OPTestSecondaryPlugin.

		self assert: OPDiagram new findPlugin equals: nil
	] ensure: [ OPPluginRegistry resetDefault ].

	customSheet := OPStyleSheet new.
	diagram styleSheet: customSheet.
	self assert: diagram styleSheet identicalTo: customSheet.
	diagram styleSheet: nil.
	self assert: diagram styleSheet class identicalTo: OPStyleSheet.

	self
		deny: diagram isRendered
		description: 'Diagram should not be rendered before assigning canvas'.
	diagram removeRender.

	canvas := RSCanvas new.
	otherCanvas := RSCanvas new.
	childNode := OPTestBoundNode in: diagram.
	childNode bounds: (OPNodeBounds withPosition: 10 @ 20 extent: 50 @ 40).
	diagram ownedElement: childNode willRenderIn: canvas.
	self
		assert: diagram isRendered
		description: 'Diagram should be marked as rendered after ownedElement:willRenderIn:'.
	diagram canvas: canvas.
	diagram renderBasicShapeIn: canvas.
	self
		should: [ diagram canvas: otherCanvas ]
		raise: AssertionFailure.
	self
		should: [ diagram renderBasicShapeIn: otherCanvas ]
		raise: Error.

	childNode renderIn: canvas.
	diagram updateFromRender.
	self assert: diagram bounds position equals: 0 @ 0.

	diagram removeRender.
	self
		deny: diagram isRendered
		description: 'Diagram should not be rendered after removeRender'.
	self
		deny: childNode isRendered
		description: 'Owned elements should also have their render removed'
]
