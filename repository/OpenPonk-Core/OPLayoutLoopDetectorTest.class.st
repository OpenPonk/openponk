"
Verifies cycle detection on directed graphs of Roassal shapes and lines in OPLayoutLoopDetector and layout fallbacks in OPLayouter.
"
Class {
	#name : 'OPLayoutLoopDetectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'boxA',
		'boxB',
		'boxC'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPLayoutLoopDetectorTest >> setUp [
	super setUp.
	boxA := RSBox new.
	boxB := RSBox new.
	boxC := RSBox new
]

{ #category : 'tests' }
OPLayoutLoopDetectorTest >> testAcyclicGraphHasNoLoops [
	| linkAB linkBC detector |
	linkAB := RSLine new from: boxA; to: boxB; yourself.
	linkBC := RSLine new from: boxB; to: boxC; yourself.
	detector := OPLayoutLoopDetector new
		boxes: { boxA . boxB . boxC };
		links: { linkAB . linkBC };
		yourself.
	self assert: detector boxes size equals: 3.
	self assert: detector links size equals: 2.
	self
		deny: detector haveLoops
		description: 'Linear chain A -> B -> C should not be reported as having loops'.
	self
		deny: (OPLayoutLoopDetector haveLoopsBoxes: { boxA . boxB . boxC } links: { linkAB . linkBC })
		description: 'Class-side loop check should return false for acyclic graph'
]

{ #category : 'tests' }
OPLayoutLoopDetectorTest >> testCyclicGraphDetectsLoop [
	| linkAB linkBC linkCA |
	linkAB := RSLine new from: boxA; to: boxB; yourself.
	linkBC := RSLine new from: boxB; to: boxC; yourself.
	linkCA := RSLine new from: boxC; to: boxA; yourself.
	self
		assert: (OPLayoutLoopDetector
			haveLoopsBoxes: { boxA . boxB . boxC }
			links: { linkAB . linkBC . linkCA })
		description: 'Directed cycle A -> B -> C -> A should be detected as loop'
]

{ #category : 'tests' }
OPLayoutLoopDetectorTest >> testHierarchicalLayouterInnerEdgesAndContainers [
	| project container diagram testCanvas projectController diagramController controllerA controllerB layouter edgeAB selfLoop externalBox externalEdge |
	project := OPProject new.
	container := OPTestContainerModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself).
	controllerA := diagramController showInDiagramModel: (container add: OPTestEntityModel new).
	controllerB := diagramController showInDiagramModel: (container add: OPTestEntityModel new).
	controllerA roassalShape translateTo: 20 @ 30.
	controllerB roassalShape translateTo: 120 @ 80.
	edgeAB := RSLine new from: controllerA roassalShape; to: controllerB roassalShape; yourself.
	selfLoop := RSLine new from: controllerA roassalShape; to: controllerA roassalShape; yourself.
	externalBox := RSBox new.
	externalEdge := RSLine new from: controllerA roassalShape; to: externalBox; yourself.
	testCanvas
		add: externalBox;
		add: edgeAB;
		add: selfLoop;
		add: externalEdge.
	layouter := OPTestLayouter new
		diagramController: diagramController;
		yourself.
	self
		assertCollection: (layouter innerEdgesFor: { controllerA roassalShape . controllerB roassalShape })
		hasSameElements: { edgeAB }.
	self
		assert: (layouter layoutInnerContentOf: diagram shapes: diagram directNodeRoassalShapes edges: { edgeAB })
		identicalTo: layouter.
	layouter layoutContainersHierarchically: { diagram }.
	self
		assert: (diagram roassalShape announcer hasSubscriber: layouter)
		description: 'layoutContainersHierarchically: should subscribe layouter to container position changes'.
	layouter unsubscribeContainers: { diagram }.
	self
		deny: (diagram roassalShape announcer hasSubscriber: layouter)
		description: 'unsubscribeContainers: should remove layouter subscription from container shape'
]

{ #category : 'tests' }
OPLayoutLoopDetectorTest >> testLayouterHierarchyAndPositionPropagation [
	| project container diagram testCanvas projectController diagramController controllerA controllerB noLayouter testLayouter hierarchicalLayouter linkAB linkBA |
	project := OPProject new.
	container := OPTestContainerModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself).
	controllerA := diagramController showInDiagramModel: (container add: OPTestEntityModel new).
	controllerB := diagramController showInDiagramModel: (container add: OPTestEntityModel new).
	noLayouter := OPNoLayouter new
		diagramController: diagramController;
		yourself.
	self
		assert: (noLayouter supports: OPGridLayoutCommand)
		description: 'OPLayouter should support OPGridLayoutCommand'.
	self assert: (noLayouter roassalShapesFor: { controllerA model }) size equals: 1.
	noLayouter defaultLayout.
	testLayouter := OPTestLayouter new
		diagramController: diagramController;
		yourself.
	testLayouter defaultLayout.
	testLayouter circleLayout.
	testLayouter gridLayout.
	testLayouter treeLayout.
	testLayouter sugiyamaLayout.
	testLayouter dominanceTreeLayout.
	linkAB := RSLine new from: controllerA roassalShape; to: controllerB roassalShape; yourself.
	linkBA := RSLine new from: controllerB roassalShape; to: controllerA roassalShape; yourself.
	testCanvas add: linkAB; add: linkBA.
	testLayouter treeLayout.
	testLayouter sugiyamaLayout.
	testLayouter dominanceTreeLayout.
	hierarchicalLayouter := OPHierarchicalNodesAndEdgesLayouter new
		diagramController: diagramController;
		yourself.
	self assert: hierarchicalLayouter allRenderedNodeShapes size equals: 2.
	self assert: hierarchicalLayouter topLevelNodeShapes size equals: 2.
	self assertEmpty: hierarchicalLayouter containerElementsBottomUp.
	self assert: (hierarchicalLayouter depthFor: controllerA diagramElement) equals: 0.
	hierarchicalLayouter wirePositionPropagationFor: controllerA diagramElement children: { controllerB roassalShape }.
	controllerA roassalShape translateBy: 10 @ 15.
	hierarchicalLayouter unsubscribeContainers: { controllerA diagramElement }
]
