printing
asString
	returnDataType isNil
		ifTrue: [ ^ name , '(' , ( parameters inject: '' into: [ :str :a | str , a , ',' ]) , ')'];
		ifFalse: [ ^ name , '(' , ( parameters inject: '' into: [ :str :a | str , a , ',' ]) , ')' , ':' , returnDataType ]
	