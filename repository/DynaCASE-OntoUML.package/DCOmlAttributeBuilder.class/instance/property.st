as yet unclassified
property
	^ super property
		==> [ :nodes | 
			Attribute new
				name: nodes second;
				dataType: nodes third;
				multiplicity: nodes fourth ]