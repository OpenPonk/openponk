accessing
labels
	^ labels ifNil: [ labels := self edges collect: labelsStrategy thenReject: #isNil ]