Class {
	#name : #DCRTLEdge,
	#superclass : #MalGraphEdge,
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #comparing }
DCRTLEdge >> = anEdge [
	self species = anEdge species
		ifFalse: [ ^ false ].
	^ self from = anEdge from & (self to = anEdge to)
]

{ #category : #comparing }
DCRTLEdge >> hash [
	^ (self species hash bitXor: self from hash) bitXor: self to hash
]

{ #category : #printing }
DCRTLEdge >> printOn: aStream [
	aStream
		nextPutAll: self from label;
		nextPutAll: '->';
		nextPutAll: self to label
]
