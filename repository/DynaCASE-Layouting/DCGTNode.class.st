Class {
	#name : 'DCGTNode',
	#superclass : 'Object',
	#instVars : [
		'edges',
		'model'
	],
	#category : 'DynaCASE-Layouting-DGT',
	#package : 'DynaCASE-Layouting',
	#tag : 'DGT'
}

{ #category : 'instance creation' }
DCGTNode class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : 'instance creation' }
DCGTNode class >> on: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : 'adding/removing' }
DCGTNode >> addEdge: aDCGTEdge [
	(edges includes: aDCGTEdge)
		ifTrue: [ ^ self ].
	edges add: aDCGTEdge
]

{ #category : 'geometry' }
DCGTNode >> degree [
	^ self edges size
]

{ #category : 'accessing' }
DCGTNode >> edges [
	<DCAssociation: ''>
	^ edges
]

{ #category : 'accessing' }
DCGTNode >> edges: aCollection [
	[ edges isNotEmpty ] whileTrue: [ self removeEdge: edges anyOne ].
	aCollection do: [ :each | self addEdge: each ]
]

{ #category : 'geometry' }
DCGTNode >> inDegree [
	^ self incoming size
]

{ #category : 'accessing' }
DCGTNode >> incoming [
	^ self edges select: [ :each | each to = self ]
]

{ #category : 'initialization' }
DCGTNode >> initialize [
	super initialize.
	edges := OrderedCollection new
]

{ #category : 'accessing' }
DCGTNode >> model [
	^ model
]

{ #category : 'accessing' }
DCGTNode >> model: anObject [
	model := anObject
]

{ #category : 'geometry' }
DCGTNode >> outDegree [
	^ self outgoing size
]

{ #category : 'accessing' }
DCGTNode >> outgoing [
	^ self edges select: [ :each | each from = self ]
]

{ #category : 'as yet unclassified' }
DCGTNode >> printOn: aStream [
	aStream nextPutAll: 'N'.
	aStream nextPut: $(.
	self model printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'adding/removing' }
DCGTNode >> removeEdge: aDCGTEdge [
	(edges includes: aDCGTEdge)
		ifFalse: [ ^ self ].
	edges remove: aDCGTEdge
]
