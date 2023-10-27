Class {
	#name : #OPRSBaselineDominanceTreeLayout,
	#superclass : #RSHorizontalDominanceTreeLayout,
	#category : #'OpenPonk-Roassal-Meta'
}

{ #category : #'as yet unclassified' }
OPRSBaselineDominanceTreeLayout >> nestingLevelFor: aNodeFigure [

	| parents parentsNesting |
	parents := self parentsFor: aNodeFigure.
	parentsNesting := parents collect: [ :eachParent |
		                  self nestingLevelFor: eachParent ].
	^ parentsNesting isEmpty
		  ifTrue: [ 0 ]
		  ifFalse: [ parentsNesting max + 1 ]
]

{ #category : #'as yet unclassified' }
OPRSBaselineDominanceTreeLayout >> parentsFor: aNode [

	^ self cachedParents at: aNode ifAbsentPut: [
		  | nodes |
		  nodes := OrderedCollection new.
		  self edgesDo: [ :edge |
			  (edge to == aNode and: [
				   edge from model name ~= 'BaselineOfOntoUMLProfile' or: [
					   edge to model name ~= 'BaselineOfClassEditor' ] ]) ifTrue: [
				  nodes add: edge from ] ].
		  nodes ]
]
