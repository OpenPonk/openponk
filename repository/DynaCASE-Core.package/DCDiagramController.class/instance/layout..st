accessing
layout: aLayout
	aLayout
		keysAndValuesDo:
			[ :key :value | (self controllers detect: [ :ctrl | ctrl model uuid = key ]) layout: value ].
	self updateView