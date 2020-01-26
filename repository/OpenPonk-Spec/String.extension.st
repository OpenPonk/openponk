Extension { #name : #String }

{ #category : #'*OpenPonk-Spec' }
String >> splitOnCapitals [
	^ '[A-Z][^A-Z]+' asRegex matchesIn: self
]
