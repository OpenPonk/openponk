removing
removeGeneralization: aGeneralization
	
	^ aGeneralization generalizationSet remove: (aGeneralization child name)
	