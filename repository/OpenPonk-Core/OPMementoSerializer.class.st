Class {
	#name : 'OPMementoSerializer',
	#superclass : 'OPSerializer',
	#instVars : [
		'plugin'
	],
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'as yet unclassified' }
OPMementoSerializer class >> exportSubject [

	^ #modelWithDiagrams
]

{ #category : 'instance creation' }
OPMementoSerializer class >> forPlugin: aPlugin [

	^ self new
		  plugin: aPlugin;
		  yourself
]

{ #category : 'adding' }
OPMementoSerializer >> addFormatNameTo: aFileReference [
	^ aFileReference
]

{ #category : 'accessing' }
OPMementoSerializer >> plugin: anOPPetriNetsPlugin [ 
	plugin := anOPPetriNetsPlugin
]
