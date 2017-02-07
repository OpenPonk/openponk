fuel - serialize/materialize
fuelSerialize: anObject
	^ (Base64MimeConverter
		mimeEncode: (FLSerializer serializeToByteArray: anObject) readStream) contents