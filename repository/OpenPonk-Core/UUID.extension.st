Extension { #name : 'UUID' }

{ #category : '*OpenPonk-Core' }
UUID >> displayStringOn: aStream [

	self printOn: aStream
]

{ #category : '*OpenPonk-Core' }
UUID class >> fromSton: stonReader [

	stonReader peek = $[ ifTrue: [
		^ super new
			  uuidData: (ByteArray fromSton: stonReader);
			  yourself ].
	^ super fromSton: stonReader
]
