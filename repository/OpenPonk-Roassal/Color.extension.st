Extension { #name : #Color }

{ #category : #'*OpenPonk-Roassal' }
Color >> withTransparencyAsWhite [

	^ self class
		  r: (self red + 1 - self alpha min: 1)
		  g: (self green + 1 - self alpha min: 1)
		  b: (self blue + 1 - self alpha min: 1)
]
