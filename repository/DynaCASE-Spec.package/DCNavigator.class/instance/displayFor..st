widget API
displayFor: anObject
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each displayFor: anObject) ifNotNil: [ :v | ^ v ] ] ]