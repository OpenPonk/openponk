fonts
fontFamilyName: name pointSize: number
	"[ TRPlatform current fontFamilyName: 'Source Sans Pro' pointSize: 12 ] benchFor: 1 second.
""a BenchmarkResult(489,886 iterations in 1 second 2 milliseconds. 488,908 per second)""

[ TRPlatform current fontFamilyName: 'Source Sans Pro' pointSize: 12 ] benchFor: 1 second.
""a BenchmarkResult(2,972,218 iterations in 1 second 1 millisecond. 2,969,249 per second)"""

	^ (self fontCache at: name ifAbsentPut: [ Dictionary new ])
		at: number
		ifAbsentPut: [ LogicalFont familyName: name pointSize: number ]