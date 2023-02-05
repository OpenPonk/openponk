Extension { #name : #RSComposite }

{ #category : #'*OpenPonk-Roassal3' }
RSComposite >> isOrComposesOf: aShape [

	^ (super isOrComposesOf: aShape) or: [ 
		  self children anySatisfy: [ :any | any isOrComposesOf: aShape ] ]
]
