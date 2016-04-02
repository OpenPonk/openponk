accessing
layout: aLayout
	aLayout
		associationsDo: [ :pair | (self controllers detect: [ :ctrl | ctrl model uuid = pair key ]) layout: pair value ].
	self updateView