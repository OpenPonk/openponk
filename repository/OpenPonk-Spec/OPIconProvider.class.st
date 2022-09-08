Class {
	#name : #OPIconProvider,
	#superclass : #SpIconProvider,
	#category : #'OpenPonk-Spec-Application'
}

{ #category : #accessing }
OPIconProvider >> iconNamed: aName ifAbsent: aBlock [

	aName ifNil: [ ^ aBlock value ].

	^ SpApplication defaultApplication iconProvider
		  iconNamed: aName
		  ifAbsent: [ 
			  OPIcons allSubclasses do: [ :any | 
				  any at: aName ifPresent: [ :icon | ^ icon ] ].
			  aBlock value ]
]
