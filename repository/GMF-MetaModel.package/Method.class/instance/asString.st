printing
asString
	^ name , '(' , (parameters inject: '' into: [ :str :a | str , a , ',' ]) , ')' , ':' , returnDataType