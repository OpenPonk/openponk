Extension { #name : 'MalGraphAlgorithm' }

{ #category : '*DynaCASE-Layouting' }
MalGraphAlgorithm >> addEdge: anEdge [
	^ self edges add: anEdge
]

{ #category : '*DynaCASE-Layouting' }
MalGraphAlgorithm >> addNode: aNode [
	^ self findNode: aNode model ifAbsent: [ nodes add: aNode ]
]

{ #category : '*DynaCASE-Layouting' }
MalGraphAlgorithm >> addNodes: aCollection [
	aCollection do: [ :each | self addNode: each ]
]

{ #category : '*DynaCASE-Layouting' }
MalGraphAlgorithm >> neighborNodesOf: aNode [
	^ self edges
		select: [ :anEdge | anEdge from model = aNode model | (anEdge to model = aNode model) ]
		thenCollect:
			[ :anEdge | 
			anEdge from = aNode
				ifTrue: [ anEdge to ]
				ifFalse: [ anEdge from ] ]
]
