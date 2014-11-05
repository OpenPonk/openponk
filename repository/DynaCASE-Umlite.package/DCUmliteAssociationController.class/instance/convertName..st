hooks
convertName: aString
	^ (aString copyReplaceAll: '>' with: '▸') copyReplaceAll: '<' with: '◂'