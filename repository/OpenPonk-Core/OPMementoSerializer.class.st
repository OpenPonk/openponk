Class {
	#name : #OPMementoSerializer,
	#superclass : #OPSerializer,
	#instVars : [
		'plugin'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'as yet unclassified' }
OPMementoSerializer class >> exportSubject [

	^ #modelWithDiagrams
]

{ #category : #'instance creation' }
OPMementoSerializer class >> forPlugin: aPlugin [

	^ self new
		  plugin: aPlugin;
		  yourself
]

{ #category : #adding }
OPMementoSerializer >> addFormatNameTo: aFileReference [
	^ aFileReference
]

{ #category : #accessing }
OPMementoSerializer >> plugin: anOPPetriNetsPlugin [ 
	plugin := anOPPetriNetsPlugin
]
