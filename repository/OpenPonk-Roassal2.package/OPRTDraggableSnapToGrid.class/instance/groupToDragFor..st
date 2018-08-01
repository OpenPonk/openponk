initialization
groupToDragFor: aView
	^ aView attributes at: OPRTSelectableView ifAbsent: [ RTGroup new ]