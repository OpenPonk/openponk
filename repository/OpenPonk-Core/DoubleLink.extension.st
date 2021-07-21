Extension { #name : #DoubleLink }

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLink >> addPredecessor: aLink [
	| oldPredeccessor |
	oldPredeccessor := self previousLink.
	oldPredeccessor nextLink: aLink.
	aLink previousLink: oldPredeccessor.
	aLink nextLink: self.
	self previousLink: aLink
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLink >> addSuccessor: aLink [
	| oldSuccessor |
	oldSuccessor := self nextLink.
	oldSuccessor previousLink: aLink.
	aLink nextLink: oldSuccessor.
	aLink previousLink: self.
	self nextLink: aLink
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLink >> next [
	^ self nextLink
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLink >> previous [
	^ self previousLink
]

{ #category : #'*OpenPonk-Core-accessing' }
DoubleLink >> removeLink [
	| predecessor successor |
	predecessor := self previousLink.
	successor := self nextLink.
	predecessor nextLink: successor.
	successor previousLink: predecessor.
	self clearLinks
]
