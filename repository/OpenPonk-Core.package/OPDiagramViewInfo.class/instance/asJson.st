serializing
asJson
	^ String
		<< [ :stream | 
			(NSPJsonWriter on: stream)
				mapInstVarsFor: self class;
				nextPut: self ]