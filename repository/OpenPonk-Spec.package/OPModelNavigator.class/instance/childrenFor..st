private
childrenFor: anObject
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each childrenFor: anObject)
						ifNotNil: [ :v | 
							self updateIfChildrenChanged: anObject children: v.
							^ v ] ] ].
	self error: 'No available adapter hasMappingFor:' , anObject asString