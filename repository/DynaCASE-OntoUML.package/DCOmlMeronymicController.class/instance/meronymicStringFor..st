as yet unclassified
meronymicStringFor: aMeronymicModel
	| parts |
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