ston - serialize/materialize
stonMaterialize: aString
	^ (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next