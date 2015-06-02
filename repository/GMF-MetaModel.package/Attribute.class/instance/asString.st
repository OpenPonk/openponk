printing
asString
	dataType isNil
		ifFalse:  [ ^ self name , ':' , self dataType , '[' , self multiplicity asString , ']' ];
		ifTrue: [ ^ self name , '[' , self multiplicity asString , ']' ]