Extension { #name : 'RSGroup' }

{ #category : '*OpenPonk-Roassal' }
RSGroup >> isInACanvas [

	^ self anySatisfy: [ :any | any isInACanvas ]
]

{ #category : '*OpenPonk-Roassal' }
RSGroup >> remove [

	self do: [ :each | each remove ]
]
