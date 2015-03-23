as yet unclassified
meronymicString
	| parts aMeronymicModel |
	aMeronymicModel := self model.
	parts := OrderedCollection new.
	aMeronymicModel isEssential
		ifTrue: [ parts add: 'essential' ].
	aMeronymicModel isInseparable
		ifTrue: [ parts add: 'inseparable' ].
	aMeronymicModel isImmutablePart
		ifTrue: [ parts add: 'immutablePart' ].
	aMeronymicModel isImmutableWhole
		ifTrue: [ parts add: 'immutableWhole' ].
	parts isEmpty
		ifTrue: [ ^ '' ].
	^ '{' , (',' join: parts) , '}'