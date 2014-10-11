accessing
layout: aLayout
	aLayout
		associationsDo: [ :pair | 
			| v |
			v := (self findControllerByModel: pair key) view.
			v translateTo: pair value ].
	self updateView