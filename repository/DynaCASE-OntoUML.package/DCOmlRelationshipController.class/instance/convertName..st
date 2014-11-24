hooks
convertName: aString
	^ aString
	"	^ (aString copyReplaceAll: '>' with: '▸') copyReplaceAll: '<' with: '◂'"