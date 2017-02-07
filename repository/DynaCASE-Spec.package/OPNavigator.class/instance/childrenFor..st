private
childrenFor: anObject
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each childrenFor: anObject) ifNotNil: [ :v | ^ v ] ] ].
	self error: 'No available adapter hasMappingFor:', anObject asString.