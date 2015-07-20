widget API
iconFor: anObject
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each iconFor: anObject) ifNotNil: [ :v | ^ v ] ] ]