printing
asString
	^ name , '(' , (parameters joinUsing: ', ') , ')' , (returnDataType ifNil: [ '' ] ifNotNil: [ ': ' , returnDataType ])