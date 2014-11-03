accessing
attributes: anObject
	attributes := anObject.
	
	attributes ifNil: [ attributes := Set new ]