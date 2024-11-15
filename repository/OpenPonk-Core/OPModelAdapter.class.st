Class {
	#name : 'OPModelAdapter',
	#superclass : 'Object',
	#instVars : [
		'model'
	],
	#category : 'OpenPonk-Core-Adapters',
	#package : 'OpenPonk-Core',
	#tag : 'Adapters'
}

{ #category : 'instance creation' }
OPModelAdapter class >> forModel: aModel [

	^ self new
		  model: aModel;
		  yourself
]

{ #category : 'comparing' }
OPModelAdapter >> = other [

	^ other = model
]

{ #category : 'reflective operations' }
OPModelAdapter >> doesNotUnderstand: aMessage [

	^ aMessage sendTo: model
]

{ #category : 'comparing' }
OPModelAdapter >> hash [

	^ model hash
]

{ #category : 'accessing' }
OPModelAdapter >> model [

	^ model
]

{ #category : 'accessing' }
OPModelAdapter >> model: aModel [

	model := aModel
]

{ #category : 'printing' }
OPModelAdapter >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that
	identifies the receiver."

	super printOn: aStream.
	aStream << '('.
	model printOn: aStream.
	aStream << ')'
]
