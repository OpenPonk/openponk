fonts
widthOfString: string font: font
	^ (self widthsCache at: string ifAbsentPut: [ Dictionary new ])
		at: font
		ifAbsentPut: [ self logCr: 'cache miss @ ' , string.
			font widthOfString: string ]