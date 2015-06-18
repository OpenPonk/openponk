parsing - private
updateMethodsFrom: aText
	| methodStrCol methodTokens |
	
	methodStrCol := (aText asString copyReplaceAll: ' ' with: '') lines.
	
	"compare count of attributes from a form and from an element"
	methodStrCol size ~= self model methods size
		ifTrue: [ self model methods: (OrderedCollection new) ].
		
	methodStrCol do: [ :each | 
		"prepare method string to split and then split it"
		methodTokens := ':' split: 
								(
									(((each copyReplaceAll: ')' with: '')
											copyReplaceAll: '(' with: ':')
											copyReplaceAll: ',' with: ':')
								).
	
		methodTokens size >= 3
			ifTrue: [ 
				((methodTokens at: 2) = '')
				 ifTrue: [ methodTokens removeAt: 2 ].
				
				self model removeMethod: (methodTokens at: 1).
				Method new
					name: (methodTokens removeAt: 1);
					returnDataType: (methodTokens removeAt: methodTokens size); 
					element: self model;
					parameters: methodTokens
			]
	].
	self refreshFigure.