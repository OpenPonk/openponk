grammar
multiplicity
	^ super multiplicity ==> [ :str | str ifNil: [ '' ] ]