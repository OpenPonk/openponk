"
I am a generic graph layouter that abstracts the extraction of nodes and edges from a diagram to apply automated structural layouts.
"
Class {
	#name : 'OPNodesAndEdgesLayouter',
	#superclass : 'OPLayouter',
	#category : 'OpenPonk-Core-Layouting',
	#package : 'OpenPonk-Core',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPNodesAndEdgesLayouter >> allEdges [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPNodesAndEdgesLayouter >> allNodes [
	^ self subclassResponsibility
]

{ #category : 'userinterface' }
OPNodesAndEdgesLayouter >> applyLayout: aTwoArgBlock [
	"Apply layout algorithm on target nodes and edges, recording geometry changes for undo/redo."
	| targetNodes snapshot commands |
	targetNodes := self targetNodes.
	snapshot := OPDiagramGeometrySnapshot onNodes: targetNodes.

	self executeLayout: aTwoArgBlock onNodes: targetNodes.

	commands := snapshot deltaCommands.
	self executeLayoutCommands: commands.
	self updateCanvas
]

{ #category : 'private' }
OPNodesAndEdgesLayouter >> executeLayout: aTwoArgBlock onNodes: aCollectionOfNodes [
	"Execute the layout algorithm block on target nodes and edges, maintaining center position for partial layouts."
	| targetEdges oldEncompassingRectangle |
	targetEdges := self targetEdgesFor: aCollectionOfNodes.
	oldEncompassingRectangle := aCollectionOfNodes encompassingRectangle.
	aTwoArgBlock value: aCollectionOfNodes value: targetEdges.
	self isPartialLayout ifTrue: [
		aCollectionOfNodes translateTo: oldEncompassingRectangle center ]
]

{ #category : 'private' }
OPNodesAndEdgesLayouter >> executeLayoutCommands: aCollectionOfCommands [
	"Execute layout delta commands within a labeled undo transaction."
	aCollectionOfCommands ifEmpty: [ ^ self ].
	diagramController undoManager
		ifNotNil: [ :activeUndoManager |
			activeUndoManager inTransactionLabeled: 'Apply Layout' do: [
				aCollectionOfCommands do: [ :eachCommand | activeUndoManager execute: eachCommand ] ] ]
		ifNil: [
			aCollectionOfCommands do: [ :eachCommand | eachCommand execute ] ]
]

{ #category : 'testing' }
OPNodesAndEdgesLayouter >> isPartialLayout [
	"Answer whether the current layout operation applies to a multi-element selection."
	^ diagramController selectedElements size > 1
]

{ #category : 'accessing' }
OPNodesAndEdgesLayouter >> targetEdgesFor: aCollectionOfNodes [
	"Answer the collection of non-loop edges interconnecting the target nodes."
	| nonLoopEdges |
	nonLoopEdges := self allEdges reject: [ :eachEdge | eachEdge to = eachEdge from ].
	^ (nonLoopEdges select: [ :eachEdge |
		(aCollectionOfNodes includes: eachEdge from) and: [ aCollectionOfNodes includes: eachEdge to ] ]) asGroup
]

{ #category : 'accessing' }
OPNodesAndEdgesLayouter >> targetNodes [
	"Answer the Roassal shape group of nodes to be positioned by the layout."
	| allNodes candidateNodes |
	allNodes := self allNodes.
	candidateNodes := self isPartialLayout
		ifTrue: [ allNodes intersection: diagramController selectedElements ]
		ifFalse: [ allNodes ].
	^ RSGroup withAll: candidateNodes
]
