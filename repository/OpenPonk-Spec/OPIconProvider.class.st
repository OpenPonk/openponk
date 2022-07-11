Class {
	#name : #OPIconProvider,
	#superclass : #SpIconProvider,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPIconProvider >> iconNamed: aName ifAbsent: aBlock [

	aName ifNil: [ ^ aBlock value ].

	^ super iconNamed: aName ifAbsent: [ 
		  OPIcons allSubclasses do: [ :any | 
			  any at: aName ifPresent: [ :icon | ^ icon ] ].
		  aBlock value ]
]
