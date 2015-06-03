parsing - private
updateAttributesFrom: aText
	| attrStrCol attrTokens |
	
	attrStrCol := (aText asString copyReplaceAll: ' ' with: '') lines.
	
	"compare count of attributes from a form and from an element"
	attrStrCol size ~= self model attributes size
		ifTrue: [ self model attributes: (OrderedCollection new) ].
		
	attrStrCol do: [ :each | 
		attrTokens := ':' split: 
								((each copyReplaceAll: '[' with: ':') copyReplaceAll: ']' with: '').
	
		attrTokens size = 3
			ifTrue: [ 
				self model removeAttribute: (attrTokens at: 1).
				Attribute 
					name: (attrTokens at: 1)
					dataType: (attrTokens at: 2)
					multiplicity: (attrTokens at: 3)
					element: self model
					 ]
	].
	self refreshFigure.