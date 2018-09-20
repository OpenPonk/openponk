serializing
asJson
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				mapInstVarsFor: self class;
				nextPut: self ]