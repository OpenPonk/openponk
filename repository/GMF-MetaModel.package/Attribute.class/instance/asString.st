printing
asString
	^ name , (dataType ifNil: [ '' ] ifNotNil: [ ': ' , dataType ])
		, (multiplicity ifNotEmpty: [ '[' , multiplicity , ']' ])