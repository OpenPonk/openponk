accessing
parents: anObject
	parents := anObject.
	
	parents ifNil: [ parents := Set new ]