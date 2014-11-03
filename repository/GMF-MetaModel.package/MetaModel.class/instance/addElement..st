adding
addElement: anElement
	[ modelElements at: anElement name ]
		on: Error
		do: [ modelElements at: anElement name put: anElement ]