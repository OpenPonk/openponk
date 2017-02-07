removing
removeIfNecessary: aHandle
	(aHandle isEnd not
		and: [ aHandle position onLineFrom: aHandle previous position to: aHandle next position ])
		ifTrue: [ aHandle remove ]