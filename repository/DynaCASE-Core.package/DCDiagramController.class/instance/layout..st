accessing
layout: aLayout
	aLayout
		keysAndValuesDo: [ :key :value | 
			self controllers
				detect: [ :ctrl | ctrl model uuid = key ]
				ifFound: [ :ctrl | ctrl layout: value ] ].
	self updateView