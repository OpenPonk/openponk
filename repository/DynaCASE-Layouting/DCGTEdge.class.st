Class {
	#name : #DCGTEdge,
	#superclass : #Object,
	#instVars : [
		'from',
		'to'
	],
	#category : 'DynaCASE-Layouting-DGT'
}

{ #category : #'instance creation' }
DCGTEdge class >> from: aSource to: aTarget [
	^ self new
		from: aSource;
		to: aTarget;
		yourself
]

{ #category : #accessing }
DCGTEdge >> from [
	<DCAssociation: ''>
	^ from
]

{ #category : #accessing }
DCGTEdge >> from: aDCGTNode [
	|oldRef|
	from = aDCGTNode ifTrue: [ ^ self ].
	oldRef := from.
	from := aDCGTNode.
	oldRef ifNotNil: [ oldRef removeEdge: self ].
	from ifNotNil: [ from addEdge: self ]
]

{ #category : #'as yet unclassified' }
DCGTEdge >> printOn: aStream [
	aStream nextPutAll: '{ '.
	self from printOn: aStream.
	aStream nextPutAll: ' -> '.
	self to printOn: aStream.
	aStream nextPutAll: ' }'
]

{ #category : #accessing }
DCGTEdge >> to [
	<DCAssociation: ''>
	^ to
]

{ #category : #accessing }
DCGTEdge >> to: aDCGTNode [
	|oldRef|
	to = aDCGTNode ifTrue: [ ^ self ].
	oldRef := to.
	to := aDCGTNode.
	oldRef ifNotNil: [ oldRef removeEdge: self ].
	to ifNotNil: [ to addEdge: self ]
]
