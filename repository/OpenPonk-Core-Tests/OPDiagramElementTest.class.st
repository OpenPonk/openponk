Class {
	#name : 'OPDiagramElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas'
	],
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'running' }
OPDiagramElementTest >> setUp [
	super setUp.
	canvas := RSCanvas new
]

{ #category : 'tests' }
OPDiagramElementTest >> testClassAndDefaultQueries [
	| element |
	self assert: OPDiagramElement isAbstract description: 'OPDiagramElement must be abstract'.
	self deny: OPTestPlainDiagramElement isAbstract description: 'Concrete subclass must not be abstract'.
	self deny: OPDiagramElement isEdge description: 'OPDiagramElement isEdge should default to false'.
	self deny: OPDiagramElement isNode description: 'OPDiagramElement isNode should default to false'.

	element := OPTestPlainDiagramElement new.
	self assert: element exists description: 'Diagram element should report exists = true'.
	self deny: element isNode description: 'Direct OPDiagramElement subclass should not be a node'.
	self deny: element isBoundNode description: 'Direct OPDiagramElement subclass should not be a bound node'.
	self assert: element bounds identicalTo: nil.
	element bounds: (10 @ 20 extent: 30 @ 40).
	self assert: element bounds identicalTo: nil.
	self assert: element captureGeometryMemento identicalTo: nil.
	element restoreGeometryFromMemento: nil.
	self
		assert: (element supportsColorChangeOfType: #bounds)
		description: 'Property with both getter and mutator should report supported'.
	self
		deny: (element supportsColorChangeOfType: #nonExistentProperty)
		description: 'Missing property should report unsupported'.
	self should: [ OPDiagramElement new renderBasicShape ] raise: SubclassResponsibility
]

{ #category : 'tests' }
OPDiagramElementTest >> testDeferredAndImmediateRoassalShapeEventsAndUnsubscribe [
	| element receivedEvents unsubscribedCount |
	element := OPTestDiagramElement new.
	receivedEvents := OrderedCollection new.
	unsubscribedCount := 0.

	element roassalShapeWhen: RSMouseClick send: #add: to: receivedEvents.
	element announcer
		when: OPDiagramElementRenderedAnnouncement
		do: [ unsubscribedCount := unsubscribedCount + 1 ]
		for: #temporarySubscriber.
	element unsubscribe: #temporarySubscriber.

	element renderIn: canvas.
	self assert: unsubscribedCount equals: 0.

	element roassalShape announce: RSMouseClick new.
	self assert: receivedEvents size equals: 1.

	element roassalShapeWhen: RSMouseDoubleClick send: #add: to: receivedEvents.
	element roassalShape announce: RSMouseDoubleClick new.
	self assert: receivedEvents size equals: 2
]

{ #category : 'tests' }
OPDiagramElementTest >> testEventForwardingToOwnerAndSelectionState [
	| boundNode parent child receivedEvents |
	boundNode := OPTestBoundNode new.
	boundNode renderIn: canvas.
	self assert: boundNode isSelectable description: 'OPTestBoundNode with OPRSSelectable should be selectable'.

	parent := OPTestPlainDiagramElement new.
	child := OPTestPlainDiagramElement new.
	child addEventForwardingToOwner.
	child owningElement: parent.
	child addEventForwardingToOwner.

	parent renderIn: canvas.
	child renderIn: canvas.
	self deny: child isSelectable description: 'Plain RSBox without selectable interaction should not be selectable'.

	receivedEvents := OrderedCollection new.
	{ RSMouseEnter . RSMouseLeave . RSMouseClick . RSMouseDoubleClick . RSMouseDragStart . RSMouseDragEnd . RSMouseDragging }
		do: [ :eventClass |
			parent roassalShape when: eventClass do: [ :evt | receivedEvents add: evt class ] for: self ].

	{ RSMouseEnter . RSMouseLeave . RSMouseClick . RSMouseDoubleClick . RSMouseDragStart . RSMouseDragEnd . RSMouseDragging }
		do: [ :eventClass |
			child roassalShape announce: eventClass new ].

	self
		assert: receivedEvents asArray
		equals: { RSMouseEnter . RSMouseLeave . RSMouseClick . RSMouseDoubleClick . RSMouseDragStart . RSMouseDragEnd . RSMouseDragging }
]

{ #category : 'tests' }
OPDiagramElementTest >> testFromStonNonUuidAndResolveModelElementsNotFound [
	| model element stonString restored |
	model := OPTestEntityModel new.
	model instVarNamed: #uuid put: 'non-uuid-identifier'.
	element := OPTestPlainDiagramElement new modelElement: model; yourself.

	stonString := STON toString: element.
	restored := STON fromString: stonString.
	self assert: restored modelElements first uuid equals: 'non-uuid-identifier'.

	self
		should: [ restored resolveModelElements: #() ]
		raise: OPDiagramInvalid.
	self
		deny: ([ restored resolveModelElements: #() ]
			on: OPDiagramInvalid
			do: [ :ex | ex resume ])
		description: 'Resolving missing model elements after resuming OPDiagramInvalid should answer false'
]

{ #category : 'tests' }
OPDiagramElementTest >> testModelElementsAndOwningElementConflictGuards [
	| ownerModel childModel parent child orphanSingle orphanMulti |
	ownerModel := OPTestContainerModel new.
	childModel := OPTestEntityModel new.
	parent := OPTestPlainDiagramElement new modelElement: ownerModel; yourself.
	child := OPTestPlainDiagramElement new owningElement: parent; yourself.

	child modelElement: ownerModel.
	self assert: child ownModelElement identicalTo: nil.
	self assert: child modelElement identicalTo: ownerModel.
	self
		should: [ child modelElements: { ownerModel . childModel } ]
		raise: Error.

	orphanSingle := OPTestPlainDiagramElement new modelElement: ownerModel; yourself.
	orphanSingle owningElement: parent.
	self assert: orphanSingle ownModelElement identicalTo: nil.
	self assert: orphanSingle modelElement identicalTo: ownerModel.

	orphanMulti := OPTestPlainDiagramElement new modelElements: { ownerModel . childModel }; yourself.
	self
		should: [ orphanMulti owningElement: parent ]
		raise: Error
]

{ #category : 'tests' }
OPDiagramElementTest >> testOwnedElementsHierarchyRenderingAndRemoval [
	| parent childNode childNonPos grandChild unrenderedChild |
	parent := OPTestBoundNode new.
	self assertEmpty: parent allOwnedShapesPositionableByUser.

	childNode := OPTestBoundNode new owningElement: parent; yourself.
	childNonPos := OPTestPlainDiagramElement new owningElement: parent; yourself.
	grandChild := OPTestBoundNode new owningElement: childNode; yourself.

	parent renderIn: canvas.
	childNode renderIn: canvas.
	childNonPos renderIn: canvas.
	grandChild renderIn: canvas.

	self assert: parent innerNodeElements asArray equals: { childNode }.
	self
		assert: parent innerNodeRoassalShapes asArray
		equals: { childNode roassalShape }.
	self
		assertCollection: parent innerDraggableRoassalShapes asArray
		hasSameElements: { childNode roassalShape . grandChild roassalShape }.
	self
		assert: parent isRenderedWithOwnedElements
		description: 'Element with all rendered descendants should report isRenderedWithOwnedElements = true'.

	unrenderedChild := OPTestPlainDiagramElement new owningElement: parent; yourself.
	self
		deny: parent isRenderedWithOwnedElements
		description: 'Adding an unrendered child must make isRenderedWithOwnedElements = false'.
	parent renderOwnedElementsWithoutController.
	self
		assert: unrenderedChild isRendered
		description: 'renderOwnedElementsWithoutController should render controllerless children'.
	self
		assert: parent isRenderedWithOwnedElements
		description: 'After rendering controllerless child, isRenderedWithOwnedElements should be true'.

	parent roundPositionsAndExtents.
	parent removeRender.
	self deny: parent isRendered description: 'Parent should no longer be rendered after removeRender'.
	self deny: childNode isRendered description: 'Child should no longer be rendered after parent removeRender'.

	parent remove.
	self assertEmpty: parent ownedElements.
	self deny: childNode owningElement exists description: 'Removed child should no longer have an existing owner'
]

{ #category : 'tests' }
OPDiagramElementTest >> testRenderGuardsZOrderAndStyleReplacement [
	| element secondCanvas attachedBox local1 local2 shared1 shared2 |
	element := OPTestPlainDiagramElement new.
	element updateRenderFromSelf.
	element pushBack.
	element pushFront.

	element renderIn: canvas.
	self assert: (element renderIn: canvas) identicalTo: element.
	self assert: (element renderBasicShapeIn: canvas) identicalTo: element.

	secondCanvas := RSCanvas new.
	self
		should: [ element renderBasicShapeIn: secondCanvas ]
		raise: Error.

	attachedBox := RSBox new size: 10; yourself.
	canvas add: attachedBox.
	element attachedShapes: { attachedBox }.

	element pushBack.
	self assert: canvas shapes first identicalTo: element roassalShape.
	element pushFront.
	self assert: canvas shapes last identicalTo: attachedBox.

	local1 := OPOpenPonkShapeStyle new fillColor: Color red; yourself.
	local2 := OPOpenPonkShapeStyle new fillColor: Color blue; yourself.
	element localStyle: local1.
	element localStyle: local2.
	self assert: element localStyle identicalTo: local2.

	shared1 := OPOpenPonkShapeStyle new strokeColor: Color green; yourself.
	shared2 := OPOpenPonkShapeStyle new strokeColor: Color yellow; yourself.
	element sharedStyle: shared1.
	element sharedStyle: shared2.
	self assert: element sharedStyle identicalTo: shared2
]
