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
OPDiagramElementTest >> testAnnouncementsAndWhenSendToAndInvisibleOnMouseShape [

	| element announcements shapeBeforeRemoval mouseShape moveEvent |
	element := OPTestPlainDiagramElement new.
	announcements := OrderedCollection new.
	element when: OPDiagramElementRenderRemovedAnnouncement send: #add: to: announcements.
	element renderIn: canvas.
	shapeBeforeRemoval := element roassalShape.
	element removeRender.
	self assert: announcements size equals: 1.
	self assert: announcements first diagramElement identicalTo: element.
	self assert: announcements first roassalShape identicalTo: shapeBeforeRemoval.

	mouseShape := OPInvisibleOnMouseShape new.
	mouseShape removeRender.
	self deny: mouseShape isRendered description: 'Removing render on unrendered OPInvisibleOnMouseShape must be idempotent'.

	mouseShape := OPInvisibleOnMouseShape renderToPosition: 15 @ 25 onCanvas: canvas.
	self assert: mouseShape isRendered description: 'OPInvisibleOnMouseShape must be rendered on canvas'.
	self assert: mouseShape roassalShape position equals: 15 @ 25.

	moveEvent := RSMouseMove new
		             position: 45 @ 65;
		             yourself.
	canvas announce: moveEvent.
	self assert: mouseShape roassalShape position equals: 45 @ 65.

	mouseShape removeRender.
	self deny: mouseShape isRendered description: 'OPInvisibleOnMouseShape must no longer be rendered after removeRender'.
	self
		deny: (canvas announcer hasSubscriber: mouseShape)
		description: 'OPInvisibleOnMouseShape must unsubscribe from canvas on removeRender'
]

{ #category : 'tests' }
OPDiagramElementTest >> testBoundNodeUnrenderedExtentPositionAndRounding [

	| node |
	node := OPTestBoundNode new.
	node bounds: (OPNodeBounds withPosition: 10.4 @ 20.6 extent: 50.2 @ 30.8).
	self assert: node position equals: 10.4 @ 20.6.
	self assert: node extent equals: 50.2 @ 30.8.
	node roundPositionsAndExtents.
	self assert: node bounds origin equals: (10.4 - 25.1) rounded @ (20.6 - 15.4) rounded.
	self assert: node bounds extent equals: 50 @ 31
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
OPDiagramElementTest >> testDirectNodeGeometryAndTranslation [

	| node |
	node := OPTestNode new.
	node translateBy: 10 @ 20.
	node translateTo: 30 @ 40.
	self deny: node isRendered description: 'Translating an unrendered OPNode must be a no-op'.

	node renderIn: canvas.
	self assert: node extent equals: 40 @ 25.
	self assert: node height equals: 25.
	node translateTo: 50 @ 60.
	self assert: node position equals: 50 @ 60.
	node translateBy: 15 @ -10.
	self assert: node position equals: 65 @ 50
]

{ #category : 'tests' }
OPDiagramElementTest >> testEdgeDefaultsMementoRoundingAndUpdateFromRender [

	| edge renderedEdge sourceNode targetNode |
	edge := OPTestEdge new.
	self assert: edge source identicalTo: OPNoShape instance.
	self assert: edge target identicalTo: OPNoShape instance.
	edge restoreGeometryFromMemento: nil.
	edge waypoints: {
			(10.4 @ 20.6).
			(30.2 @ 40.8) }.
	edge roundPositionsAndExtents.
	self assert: edge waypoints equals: {
			(10 @ 21).
			(30 @ 41) }.

	sourceNode := OPTestBoundNode new
		              bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 40 @ 40);
		              renderIn: canvas;
		              yourself.
	targetNode := OPTestBoundNode new
		              bounds: (OPNodeBounds withPosition: 200 @ 0 extent: 40 @ 40);
		              renderIn: canvas;
		              yourself.
	renderedEdge := OPTestEdge new
		                source: sourceNode;
		                target: targetNode;
		                renderIn: canvas;
		                yourself.
	renderedEdge updateFromRender.
	self denyEmpty: renderedEdge waypoints
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
