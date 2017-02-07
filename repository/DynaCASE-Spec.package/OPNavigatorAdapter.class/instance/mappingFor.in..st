private
mappingFor: anObject in: aDictionary
	| h |
	h := self hierarchyFor: anObject class.
	h do: [ :each | aDictionary at: each ifPresent: [ :value | ^ self cull: value with: anObject ] ].
	^ nil