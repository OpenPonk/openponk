"
Customized NeoJSONWriter. 
Enforces deterministic outputs by pretty-printing, utilizing LF line endings exclusively, and sorting properties lexicographically.
"
Class {
	#name : 'OPJsonWriter',
	#superclass : 'NeoJSONWriter',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'initialization' }
OPJsonWriter >> initialize [
	super initialize.
	self newLine: String lf.
	self prettyPrint: true
]

{ #category : 'writing' }
OPJsonWriter >> writeObject: anObject [
	| mapping |
	mapping := self mappingFor: anObject class.
	mapping sortProperties.
	mapping
		writeObject: anObject
		on: self
]
