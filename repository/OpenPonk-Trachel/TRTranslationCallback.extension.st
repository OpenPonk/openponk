Extension { #name : #TRTranslationCallback }

{ #category : #'*OpenPonk-Trachel' }
TRTranslationCallback class >> translateArray: anArray [
	^ self block: [ :shape :step | anArray do: [ :each | each translateBy: step ] ]
]

{ #category : #'*OpenPonk-Trachel' }
TRTranslationCallback class >> with: aShape [
	^ self translateArray: (Array with: aShape)
]
