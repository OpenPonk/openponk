Extension { #name : #DoubleLinkedList }

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLinkedList >> firstLink [
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ head
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLinkedList >> head [
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ head
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLinkedList >> lastLink [
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLinkedList >> linksDo: aBlock [
	| aLink |
	aLink := head.
	[ aLink == nil ]
		whileFalse: [ 
			aBlock value: aLink.
			aLink := aLink nextLink ]
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLinkedList >> tail [
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail
]
