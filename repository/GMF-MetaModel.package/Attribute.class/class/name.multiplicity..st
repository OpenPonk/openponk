instance creation
name: xName multiplicity: xMultiplicity
	"this constructor is only for use in class DataForGenerator to create Attribute of composition. Do not use it in another class"
	^(super new initialize)
		name:		xName;
		multiplicity:	xMultiplicity;
		yourself