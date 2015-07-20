parsing - private
updateMethodsFrom: aText
	self model methods copy do: [ :each | self model removeMethod: each name ].

	aText asString
		linesDo: [ :line | 
			| method |
			method := methodParser parse: line.
			method isPetitFailure
				ifFalse: [ method element: self model ] ].

	self refreshFigure