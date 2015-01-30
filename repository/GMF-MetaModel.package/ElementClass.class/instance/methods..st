accessing
methods: aSet
	methods := aSet.
	methods ifNil: [ methods := #() ].
	self changed