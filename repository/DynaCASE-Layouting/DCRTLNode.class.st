Class {
	#name : 'DCRTLNode',
	#superclass : 'MalGraphNode',
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'comparing' }
DCRTLNode >> = aNode [
	self species = aNode species
		ifFalse: [ ^ false ].
	^ self model = aNode model
]

{ #category : 'comparing' }
DCRTLNode >> hash [
	| hash |
	hash := self species hash.
	^ hash bitXor: self model hash
]

{ #category : 'testing' }
DCRTLNode >> isCluster [
	^ false
]

{ #category : 'testing' }
DCRTLNode >> isFeature [
	^ false
]

{ #category : 'testing' }
DCRTLNode >> isPosition [
	^ false
]

{ #category : 'printing' }
DCRTLNode >> printOn: stream [
	stream nextPutAll: self label
]
