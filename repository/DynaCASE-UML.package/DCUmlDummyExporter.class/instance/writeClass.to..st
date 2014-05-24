private 
writeClass: aClass to: aStream
	self writeStereotype: aClass features stereotype to: aStream.
	aStream lf.
	self writeName: aClass name withFeatures: aClass features to: aStream.
	aStream lf.
	self writeLineTo: aStream.
	self writeAttributes: aClass attributes to: aStream.
	aStream lf.
	self writeLineTo: aStream.
	self writeOperations: aClass operations to: aStream.