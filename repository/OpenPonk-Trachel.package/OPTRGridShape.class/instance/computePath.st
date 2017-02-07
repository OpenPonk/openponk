as yet unclassified
computePath
	| size spacing |
	size := 500.
	spacing := 20.
	path := self athensCanvas
		createPath:
			[ :builder | 
			builder absolute.
			size negated to: size by: spacing do:
				[ :i | 
				builder
					moveTo: size negated @ i;
					lineTo: size @ i.
				builder
					moveTo: i @ size negated;
					lineTo: i @ size ] ]