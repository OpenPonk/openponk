printing
asString
	^ name , (dataType ifNotNil: [ ': ' , dataType ]) , (multiplicity ifNotEmpty: [ '[' , multiplicity , ']' ])