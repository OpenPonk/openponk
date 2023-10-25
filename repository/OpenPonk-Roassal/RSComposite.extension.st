Extension { #name : #RSComposite }

{ #category : #'*OpenPonk-Roassal' }
RSComposite >> isOrComposesOf: aShape [

	^ (super isOrComposesOf: aShape) or: [ 
		  self children anySatisfy: [ :any | any isOrComposesOf: aShape ] ]
]
