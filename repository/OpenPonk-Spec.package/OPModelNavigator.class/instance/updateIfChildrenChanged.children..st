private
updateIfChildrenChanged: anObject children: aCollection
	| newHashes |
	newHashes := aCollection asArray collect: #hash.
	childrenMap at: anObject ifAbsentPut: [ newHashes ].
	(childrenMap at: anObject) = newHashes
		ifTrue: [ ^ self ].
	childrenMap at: anObject put: newHashes.
	self tree updateTree