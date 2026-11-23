"
Layout algorithm extending the horizontal dominance tree layout, specifically tailored to handle OpenPonk baseline dependency hierarchies and nesting levels.
"
Class {
	#name : 'OPRSBaselineDominanceTreeLayout',
	#superclass : 'RSHorizontalDominanceTreeLayout',
	#category : 'OpenPonk-Roassal-Meta',
	#package : 'OpenPonk-Roassal',
	#tag : 'Meta'
}

{ #category : 'private' }
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
