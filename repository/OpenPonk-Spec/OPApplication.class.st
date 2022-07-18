"
Spec Application for OpenPonk
"
Class {
	#name : #OPApplication,
	#superclass : #SpApplication,
	#category : #'OpenPonk-Spec-Application'
}

{ #category : #'private - factory' }
OPApplication >> newIconProvider [

	^ OPIconProvider new
]

{ #category : #running }
OPApplication >> start [

	OPProjectBrowser open
]

{ #category : #'accessing - backend' }
OPApplication >> useBackend: aName with: aConfiguration [

	aName = self class defaultBackendName ifFalse: [ 
		self error:
			'Only ' , self class defaultBackendName
			, ' is supported by OpenPonk' ]
]
