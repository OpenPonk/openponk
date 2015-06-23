parsing - private
updateAttributesFrom: aText
	self model attributes do: [ :each | self model removeAttribute: each name ].

	aText asString
		linesDo: [ :line | 
			| attribute |
			attribute := attributeParser parse: line.
			attribute isPetitFailure
				ifFalse: [ attribute element: self model ] ].

	self refreshFigure