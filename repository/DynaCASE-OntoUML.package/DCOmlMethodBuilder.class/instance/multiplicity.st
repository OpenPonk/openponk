grammar
multiplicity
	^ super multiplicity ==> [ :str | str ifNil: [ '' ] ifNotNil: [ '[' , str , ']' ] ]