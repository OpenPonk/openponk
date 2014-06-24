accessing
umletConverter
	^ umletConverter ifNil: [ umletConverter := DCSmToUmletConverter new ]