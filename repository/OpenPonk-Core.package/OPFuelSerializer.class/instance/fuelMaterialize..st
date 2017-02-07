fuel - serialize/materialize
fuelMaterialize: aString
	^ FLMaterializer
		materializeFromByteArray: (Base64MimeConverter mimeDecodeToBytes: aString readStream)