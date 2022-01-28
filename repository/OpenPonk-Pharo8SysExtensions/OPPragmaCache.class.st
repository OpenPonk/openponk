Class {
	#name : #OPPragmaCache,
	#superclass : #Object,
	#classInstVars : [
		'pragmaCache'
	],
	#category : #'OpenPonk-Pharo8SysExtensions'
}

{ #category : #accessing }
OPPragmaCache class >> pragmaCache [

	^ pragmaCache ifNil: [ pragmaCache := Dictionary new ]
]
