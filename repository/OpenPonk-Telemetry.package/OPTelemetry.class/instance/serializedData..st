reporting
serializedData: data
	^ ZnEntity with: (STON toJsonString: data) type: self mimeType