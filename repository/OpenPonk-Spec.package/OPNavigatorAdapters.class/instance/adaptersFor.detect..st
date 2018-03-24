accessing - private
adaptersFor: anObject detect: aOneArgSymbol
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each perform: aOneArgSymbol with: anObject) ifNotNil: [ :v | ^ v ] ] ]