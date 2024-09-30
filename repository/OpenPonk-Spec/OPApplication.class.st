"
Spec Application for OpenPonk
"
Class {
	#name : 'OPApplication',
	#superclass : 'SpApplication',
	#category : 'OpenPonk-Spec-Application',
	#package : 'OpenPonk-Spec',
	#tag : 'Application'
}

{ #category : 'private - factory' }
OPApplication >> newIconProvider [

	^ OPIconProvider new
]

{ #category : 'running' }
OPApplication >> start [

	OPProjectBrowser open
]

{ #category : 'accessing - backend' }
OPApplication >> useBackend: aName with: aConfiguration [

	aName = #Morphic ifFalse: [ 
		self error: 'Only Morphic is supported by OpenPonk' ].
	^ super useBackend: aName with: aConfiguration
]
