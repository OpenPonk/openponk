Extension { #name : #String }

{ #category : #'*OpenPonk-Core' }
String >> includesNumber [
	^ self anySatisfy: [ :any | any asString asInteger isNotNil ]
]
