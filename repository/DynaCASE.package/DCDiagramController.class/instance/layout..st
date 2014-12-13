accessing
layout: aLayout
	aLayout
		associationsDo: [ :pair | (self controllers detect: [ :ctrl | ctrl model dcID = pair key ]) layout: pair value ].
	self updateView