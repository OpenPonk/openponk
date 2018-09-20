Extension { #name : #TRRemoveCallback }

{ #category : #'*OpenPonk-Trachel' }
TRRemoveCallback class >> removeArray: anArray [
	^ self block: [ anArray do: [ :each | each view ifNotNil: [ each remove ] ] ]
]

{ #category : #'*OpenPonk-Trachel' }
TRRemoveCallback class >> with: first [
	^ self removeArray: (Array with: first)
]

{ #category : #'*OpenPonk-Trachel' }
TRRemoveCallback class >> with: first with: second [
	^ self removeArray: (Array with: first with: second)
]

{ #category : #'*OpenPonk-Trachel' }
TRRemoveCallback class >> with: first with: second with: third [
	^ self removeArray: (Array with: first with: second with: third)
]
