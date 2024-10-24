Extension { #name : 'UUID' }

{ #category : '*OpenPonk-Core' }
UUID class >> fromSton: stonReader [
	"Backwards compatibility - UUID used to be printed differently"

	stonReader peek = $[ ifTrue: [
		^ super new
			  uuidData: (ByteArray fromSton: stonReader);
			  yourself ].
	^ super fromSton: stonReader
]
