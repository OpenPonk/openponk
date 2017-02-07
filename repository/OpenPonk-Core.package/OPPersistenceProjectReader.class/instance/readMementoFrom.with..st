reading
readMementoFrom: aFolder with: aSerializer
	^ (aSerializer loadMementoFrom: aFolder) ifNil: [ self error: 'Unable to deserialize memento from ', aFolder asString ]