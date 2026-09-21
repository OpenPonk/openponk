"
Custom Spec icon provider for OpenPonk. 
Resolves icon requests by querying OpenPonk's centralized icon registries.
"
Class {
	#name : 'OPIconProvider',
	#superclass : 'SpIconProvider',
	#category : 'OpenPonk-Spec-Application',
	#package : 'OpenPonk-Spec',
	#tag : 'Application'
}

{ #category : 'accessing' }
OPIconProvider >> iconNamed: aName ifAbsent: aBlock [
	aName ifNil: [ ^ aBlock value ].
	^ SpApplication defaultApplication iconProvider
		iconNamed: aName
		ifAbsent: [
			OPIcons allSubclasses do: [ :iconsClass |
				(iconsClass at: aName ifAbsent: [ nil ]) ifNotNil: [ :icon | ^ icon ] ].
			aBlock value ]
]
