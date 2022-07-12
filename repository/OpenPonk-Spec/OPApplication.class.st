Class {
	#name : #OPApplication,
	#superclass : #SpApplication,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'accessing - backend' }
OPApplication >> useBackend: aName with: aConfiguration [

	aName = self class defaultBackendName ifFalse: [ 
		self error:
			'Only ' , self class defaultBackendName
			, ' is supported by OpenPonk' ]
]
