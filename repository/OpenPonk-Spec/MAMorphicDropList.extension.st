Extension { #name : #MAMorphicDropList }

{ #category : #'*OpenPonk-Spec' }
MAMorphicDropList >> buildMorphView [

	^ (DropListMorph
		   on: self
		   list: #strings
		   selected: #getIndex
		   changeSelected: #setIndex:) yourself
]

{ #category : #'*OpenPonk-Spec' }
MAMorphicDropList >> getIndex [

	^ self options indexOf: self value ifAbsent: 0
]

{ #category : #'*OpenPonk-Spec' }
MAMorphicDropList >> setIndex: anInteger [

	self value: (self options at: anInteger)
]
