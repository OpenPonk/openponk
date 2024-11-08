Extension { #name : 'StPathPresenter' }

{ #category : '*OpenPonk-Core' }
StPathPresenter >> file: aFile [

	| parts |
	self flag: 'Remove (replace by version in NewTools) in Pharo 13'.
	self initializeLayout.
	parts := aFile asAbsolute fullPath withParents.
	Smalltalk os isWindows ifTrue: [
		parts first isRoot ifTrue: [ parts := parts copyWithoutFirst ] ].
	parts
		do: [ :path | self addLinkTo: path ]
		separatedBy: [ self addSeparator ]
]
