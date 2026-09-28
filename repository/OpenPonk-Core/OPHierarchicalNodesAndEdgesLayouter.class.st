"
An automatic diagram layouter that positions nodes and routes connections using a hierarchical layer-based layout algorithm.
"
Class {
	#name : 'OPHierarchicalNodesAndEdgesLayouter',
	#superclass : 'OPNodesAndEdgesLayouter',
	#category : 'OpenPonk-Core-Layouting',
	#package : 'OpenPonk-Core',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPHierarchicalNodesAndEdgesLayouter >> allRenderedNodeShapes [
	"Answers all roassal shapes for rendered node controllers in the diagram."

	^ (diagramController controllers
		   select: [ :eachController |
				   eachController diagramElement isBoundNode and: [
						   eachController roassalShape isNotNil and: [
								   eachController diagramElement isRendered and: [
									   eachController diagramElement isPositionableByUser or: [ eachController diagramElement isResizableByUser ] ] ] ] ]
		   thenCollect: #roassalShape) asGroup
]

{ #category : 'accessing' }
OPHierarchicalNodesAndEdgesLayouter >> containerControllersBottomUp [
	"Answers all active container controllers in diagram, ordered bottom-up by nesting depth (deepest first)."

	| containerControllers |
	containerControllers := diagramController controllers select: [ :eachController |
		eachController isContainer and: [ eachController ~~ diagramController ] ].
	^ containerControllers asOrderedCollection sorted: [ :controllerA :controllerB |
		(self depthFor: controllerA) > (self depthFor: controllerB) ]
]

{ #category : 'accessing' }
OPHierarchicalNodesAndEdgesLayouter >> containerElementsBottomUp [
	"Answers all active container diagram elements in diagram, ordered bottom-up by nesting depth (deepest first)."
	| rootDiagram containerElements |
	rootDiagram := diagramController diagramElement.
	containerElements := rootDiagram allOwnedElements select: [ :eachElement |
		eachElement isContainer and: [ eachElement ~~ rootDiagram ] ].
	^ (containerElements asOrderedCollection sorted: [ :elementA :elementB |
		(self depthFor: elementA) > (self depthFor: elementB) ]) asArray
]

{ #category : 'private' }
OPHierarchicalNodesAndEdgesLayouter >> depthFor: aContainerElement [
	"Answers the nesting depth of a container diagram element relative to diagram root."
	| depth currentParent rootDiagram |
	depth := 0.
	rootDiagram := diagramController diagramElement.
	currentParent := aContainerElement owningElement.
	[ currentParent isNotNil and: [ currentParent isContainer and: [ currentParent ~~ rootDiagram ] ] ] whileTrue: [
		depth := depth + 1.
		currentParent := currentParent owningElement ].
	^ depth
]

{ #category : 'accessing' }
OPHierarchicalNodesAndEdgesLayouter >> innerEdgesFor: aCollectionOfShapes [
	"Answers edges whose source and target shapes are both included in the given collection of shapes."

	| nonLoopEdges |
	nonLoopEdges := self allEdges reject: [ :eachEdge | eachEdge to = eachEdge from ].
	^ (nonLoopEdges select: [ :eachEdge |
		(aCollectionOfShapes includes: eachEdge from) and: [
			aCollectionOfShapes includes: eachEdge to ] ]) asGroup
]

{ #category : 'layouts' }
OPHierarchicalNodesAndEdgesLayouter >> layoutContainersHierarchically: aCollectionOfContainerElements [
	"Layouts each container element from bottom to top, adapting its bounds and wiring delta position propagation."
	aCollectionOfContainerElements do: [ :eachContainerElement |
		| directShapes directEdges |
		directShapes := eachContainerElement directNodeRoassalShapes.
		directShapes ifNotEmpty: [
			directEdges := self innerEdgesFor: directShapes.
			self layoutInnerContentOf: eachContainerElement shapes: directShapes edges: directEdges.
			eachContainerElement adaptBoundsToInnerBounds: directShapes encompassingRectangle.
			self wirePositionPropagationFor: eachContainerElement children: directShapes ] ]
]

{ #category : 'layouts' }
OPHierarchicalNodesAndEdgesLayouter >> layoutInnerContentOf: aContainerElement shapes: directShapes edges: directEdges [
	"Lays out direct child shapes within a container. Subclasses specify their notation layout strategy."
	^ self
]

{ #category : 'accessing' }
OPHierarchicalNodesAndEdgesLayouter >> topLevelNodeShapes [
	"Answers all rendered shapes belonging to diagram elements at the root level of the diagram."
	^ diagramController diagramElement directNodeRoassalShapes
]

{ #category : 'layouts' }
OPHierarchicalNodesAndEdgesLayouter >> unsubscribeContainers: aCollectionOfContainerElements [
	"Unsubscribes from position change events on all container shapes."
	aCollectionOfContainerElements do: [ :eachContainerElement |
		eachContainerElement roassalShape announcer unsubscribe: self ]
]

{ #category : 'layouts' }
OPHierarchicalNodesAndEdgesLayouter >> wirePositionPropagationFor: aContainerElement children: aCollectionOfShapes [
	"Subscribes to container shape position change to synchronously translate its direct children by delta."
	aContainerElement roassalShape
		when: RSPositionChangedEvent
		do: [ :event |
			| delta |
			delta := event newPosition - event oldPosition.
			aCollectionOfShapes do: [ :eachChildShape | eachChildShape translateBy: delta ] ]
		for: self
]
