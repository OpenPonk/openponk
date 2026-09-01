"
Serializer responsible for exporting and importing memento objects, which represent snapshots of project state used for undo/redo and persistence operations.
"
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

{ #category : 'accessing' }
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
