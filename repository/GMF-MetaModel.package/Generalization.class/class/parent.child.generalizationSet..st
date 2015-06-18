instance-creation
parent: aParent child: aChild generalizationSet: aGeneralizationSet

	^ (super new initialize)
	child: aChild;
	parent: aParent;
	generalizationSet: aGeneralizationSet;
	yourself 