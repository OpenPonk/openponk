accessing
announcer
	announcer ifNil: [ self announcer: Announcer new ].
	^ announcer