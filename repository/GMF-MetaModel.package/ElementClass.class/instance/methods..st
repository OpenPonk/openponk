accessing
methods: aSet
	methods := aSet.
	methods ifNil: [ methods := Set new ].
	self changed