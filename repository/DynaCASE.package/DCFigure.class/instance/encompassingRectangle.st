accessing
encompassingRectangle
	^ self figures
		ifEmpty: [ 0 @ 0 corner: 0 @ 0 ]
		ifNotEmpty: [ Rectangle merging: (self figures collect: #encompassingRectangle) ]