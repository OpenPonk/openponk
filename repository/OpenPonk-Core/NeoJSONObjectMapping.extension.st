Extension { #name : #NeoJSONObjectMapping }

{ #category : #'*OpenPonk-Core' }
NeoJSONObjectMapping >> sortProperties [
	properties := properties sorted: #propertyName ascending
]
