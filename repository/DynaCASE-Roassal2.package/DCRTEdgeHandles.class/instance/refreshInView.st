as yet unclassified
refreshInView
	handles
		do: [ :each | 
			| el |
			el := each element.
			edge view add: el ]