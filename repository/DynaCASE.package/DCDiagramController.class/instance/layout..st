accessing
layout: aLayout
	aLayout
		associationsDo: [ :pair | 
			| v |
			v := (self controllerForModel: pair key) view.
			v translateTo: pair value ].
	self updateView