Extension { #name : #RTAbstractGraphLayout }

{ #category : #'*OpenPonk-Roassal2' }
RTAbstractGraphLayout >> parentsFor: aNode [

	^ self cachedParents at: aNode ifAbsentPut: [ 
		  | nodes |
		  nodes := OrderedCollection new.
		  self edgesDo: [ :edge | 
			  (edge to == aNode and: [ edge from ~= aNode ]) ifTrue: [ 
				  nodes add: edge from ] ].
		  nodes ]
]
