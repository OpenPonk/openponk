Extension { #name : 'RSLocation' }

{ #category : '*OpenPonk-Roassal' }
RSLocation >> stick: movableShape onPositionChangeOf: baseShape [

	| block |
	block := [ self move: movableShape on: baseShape ].
	block value.
	baseShape when: RSPositionChangedEvent do: block for: self
]
