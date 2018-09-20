Class {
	#name : #OPNavigatorAdapterTest,
	#superclass : #OPTestCase,
	#instVars : [
		'adapter',
		'diagram',
		'element',
		'edge'
	],
	#category : 'OpenPonk-Spec-Utils'
}

{ #category : #accessing }
OPNavigatorAdapterTest >> adapterClass [
	^ OPDefaultNavigatorAdapter
]

{ #category : #asserting }
OPNavigatorAdapterTest >> childrenFor: anObject equals: aCollection [
	^ self assertCollection: (adapter childrenFor: anObject) hasSameElements: aCollection
]

{ #category : #asserting }
OPNavigatorAdapterTest >> displayFor: anObject equals: aString [
	^ self assert: (adapter displayFor: anObject) equals: aString
]

{ #category : #asserting }
OPNavigatorAdapterTest >> iconFor: anObject equals: aForm [
	^ self assert: (adapter iconFor: anObject) equals: aForm
]

{ #category : #running }
OPNavigatorAdapterTest >> setUp [
	super setUp.
	adapter := self adapterClass new.
	diagram := OPDiagram named: 'Default Diagram'.
	element := OPNamedElement named: 'Default Element'.
	edge := (OPEdge from: element to: element) name: 'Default Edge'.
	diagram
		add: element;
		add: edge
]

{ #category : #'as yet unclassified' }
OPNavigatorAdapterTest >> testCull [
	self assert: (adapter cull: #name with: diagram) equals: diagram name.
	self assert: (adapter cull: [ :obj | obj name , '+' ] with: diagram) equals: diagram name , '+'.
	self assert: (adapter cull: 'string' with: diagram) equals: 'string'.
	self assert: (adapter cull: 46 with: diagram) equals: 46
]

{ #category : #'as yet unclassified' }
OPNavigatorAdapterTest >> testDefaultChildren [
	self childrenFor: element equals: #().
	self childrenFor: edge equals: #().
	self childrenFor: diagram equals: (Array with: element with: edge)
]

{ #category : #'as yet unclassified' }
OPNavigatorAdapterTest >> testDefaultDisplay [
	self displayFor: diagram equals: diagram name , ' (', #OPDiagram, ')'.
	self displayFor: element equals: element name , ' (', #OPNamedElement, ')'.
	self displayFor: edge equals: edge name , ' (', #OPEdge, ')'
]
