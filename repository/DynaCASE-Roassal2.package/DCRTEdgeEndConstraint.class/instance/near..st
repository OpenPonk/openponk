accessing
near: anOrigin
	anOrigin = #start | (anOrigin = #end)
		ifFalse: [ self error: 'start or end must be defined' ].
	origin := anOrigin