accessing
associations: anObject
	associations := anObject.
	
	associations ifNil: [ associations := Set new ]