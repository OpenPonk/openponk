Class {
	#name : #DCRTLGraph,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #accessing }
DCRTLGraph >> edges [
	^ edges
]

{ #category : #accessing }
DCRTLGraph >> edges: aCollection [
	edges := aCollection
]

{ #category : #initialization }
DCRTLGraph >> initialize [
	super initialize.
	edges := OrderedCollection new.
	nodes := OrderedCollection new
]

{ #category : #'as yet unclassified' }
DCRTLGraph >> neighborsOf: aNode [
	^ edges
		select: [ :pair | pair key = aNode | (pair value = aNode) ]
		thenCollect: [ :pair | 
			pair key = aNode
				ifTrue: [ pair value ]
				ifFalse: [ pair key ] ]
]

{ #category : #accessing }
DCRTLGraph >> nodes [
	^ nodes
]

{ #category : #accessing }
DCRTLGraph >> nodes: aCollection [
	nodes := aCollection
]
