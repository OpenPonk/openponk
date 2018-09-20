accessing
project: aProject
	project := SRToOneLink
		on: self
		slot: #project
		oppositeSlot: #views
		updateFrom: project
		to: aProject