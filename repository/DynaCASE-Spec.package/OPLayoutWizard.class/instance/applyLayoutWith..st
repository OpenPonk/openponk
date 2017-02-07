as yet unclassified
applyLayoutWith: aDictionary
	| algo keyPairs |
	algo := (aDictionary at: #algorithm) key new.
"	algo translator: (RTSmoothLayoutTranslator new nbCycles: 0.5)."
	(algo isKindOf: RTAbstractRegularTreeLayout)
		ifTrue: [ algo doNotAttachPoint ].
	keyPairs := aDictionary keys
		select: [ :each | each beginsWith: 'perform_' ]
		thenCollect: [ :each | each -> ((each withoutPrefix: 'perform_') , ':') asSymbol ].
	keyPairs
		do: [ :each | 
			(algo respondsTo: each value)
				ifTrue: [ | val |
					val := aDictionary at: each key.
					algo
						perform: each value
						with:
							(val isString
								ifTrue: [ val asNumber ]
								ifFalse: [ val ]) ] ].
	controller applyLayout: algo