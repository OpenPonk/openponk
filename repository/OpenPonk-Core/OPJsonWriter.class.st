"
unlike my parent, by default I

* pretty print
* output with LF instead of CR
* sort properties lexicographically
"
Class {
	#name : #OPJsonWriter,
	#superclass : #NeoJSONWriter,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #initialization }
OPJsonWriter >> initialize [
	super initialize.
	self newLine: String lf.
	self prettyPrint: true
]

{ #category : #writing }
OPJsonWriter >> writeObject: anObject [
	| mapping |
	mapping := self mappingFor: anObject class.
	mapping sortProperties.
	mapping
		writeObject: anObject
		on: self
]
