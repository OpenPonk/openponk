adding
addAll
	DCPlugin allSubclassesDo: [ :each | self addPlugin: each new ]