Class {
	#name : 'DCRTLBipartiteGraph',
	#superclass : 'Object',
	#instVars : [
		'leftNodes',
		'rightNodes',
		'edges'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'accessing' }
DCRTLBipartiteGraph >> edges [
	^ edges
]

{ #category : 'accessing' }
DCRTLBipartiteGraph >> edges: aCollection [
	edges := aCollection
]

{ #category : 'initialization' }
DCRTLBipartiteGraph >> initialize [
	super initialize.
	edges := OrderedCollection new.
	leftNodes := OrderedCollection new.
	rightNodes := OrderedCollection new
]

{ #category : 'accessing' }
DCRTLBipartiteGraph >> leftNodes [
	^ leftNodes
]

{ #category : 'accessing' }
DCRTLBipartiteGraph >> leftNodes: aCollection [
	leftNodes := aCollection
]

{ #category : 'accessing' }
DCRTLBipartiteGraph >> nodes [
	^ leftNodes , rightNodes
]

{ #category : 'accessing' }
DCRTLBipartiteGraph >> rightNodes [
	^ rightNodes
]

{ #category : 'accessing' }
DCRTLBipartiteGraph >> rightNodes: aCollection [
	rightNodes := aCollection
]
