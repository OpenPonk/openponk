Extension { #name : 'RSComposite' }

{ #category : '*OpenPonk-Roassal' }
RSComposite >> isOrComposesOf: aShape [

	^ (super isOrComposesOf: aShape) or: [ 
		  self children anySatisfy: [ :any | any isOrComposesOf: aShape ] ]
]

{ #category : '*OpenPonk-Roassal' }
RSComposite >> text [
	| labels |
	labels := self children select: [ :each | each respondsTo: #text ].
	labels ifEmpty: [ ^ '' ].
	^ (labels collect: #text) joinUsing: Character cr
]
