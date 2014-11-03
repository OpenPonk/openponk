instance creation
parentClass: xParentClass child: xChild

	^ ( super new initialize )
		parentClass: xParentClass;
		child: xChild;
		yourself