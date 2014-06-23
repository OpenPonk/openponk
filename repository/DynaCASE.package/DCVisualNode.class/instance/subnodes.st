accessing
subnodes
	^ subnodes ifNil: [ subnodes := OrderedCollection new ]