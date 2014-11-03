accessing
methods: anObject
	methods := anObject.
	
	methods ifNil: [ methods := Set new ]