Class {
	#name : 'OPSerializer',
	#superclass : 'Object',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'as yet unclassified' }
OPSerializer class >> exportInfo [

	^ OPExportInfo new
		  subject: self exportSubject;
		  version: self exportVersion;
		  format: self formatName
]

{ #category : 'as yet unclassified' }
OPSerializer class >> exportSubject [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPSerializer class >> exportVersion [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPSerializer class >> fileExtension [

	^ self fileExtensions first
]

{ #category : 'accessing' }
OPSerializer class >> fileExtensions [

	^ { self formatName }
]

{ #category : 'as yet unclassified' }
OPSerializer class >> forExportInfo: anExportInfo [

	| possibleClasses |
	possibleClasses := self withAllSubclasses select: [ :each |
		                   each supportsExportInfo: anExportInfo ].
	possibleClasses ifEmpty: [
		self error:
			'This version of OpenPonk does not support given format/version of project file. Try loading the project in latest build' ].
	^ (possibleClasses sorted: [ :a :b |
		   a maxImportVersion = b maxImportVersion
			   ifTrue: [ a minImportVersion > b minImportVersion ]
			   ifFalse: [ a maxImportVersion > b maxImportVersion ] ]) first
		  new
]

{ #category : 'as yet unclassified' }
OPSerializer class >> forExportInfoFile: aFile [

	^ self forExportInfo: (aFile asFileReference readStreamDo: [ :s | 
			   (NeoJSONReader on: s) nextAs: OPExportInfo ])
]

{ #category : 'as yet unclassified' }
OPSerializer class >> formatName [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPSerializer class >> maxImportVersion [

	^ self exportVersion
]

{ #category : 'as yet unclassified' }
OPSerializer class >> minImportVersion [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPSerializer class >> saveExportInfoTo: aDirectory [

	| exportInfo exportInfoFile |
	exportInfo := self exportInfo.
	exportInfoFile := aDirectory / exportInfo class fileName.
	exportInfoFile writeStreamDo: [ :s | 
		(OPJsonWriter on: s) nextPut: exportInfo ]
]

{ #category : 'accessing' }
OPSerializer class >> supportsExportInfo: anExportInfo [

	^ [ 
	  anExportInfo subject = self exportSubject and: [ 
		  anExportInfo format = self formatName and: [ 
			  anExportInfo version
				  between: self minImportVersion
				  and: self maxImportVersion ] ] ]
		  on: SubclassResponsibility
		  do: [ false ]
]

{ #category : 'accessing' }
OPSerializer >> fileExtension [
	^ self class fileExtension
]

{ #category : 'accessing' }
OPSerializer >> fileExtensions [
	^ self class fileExtensions
]

{ #category : 'formatting' }
OPSerializer >> formatName [
	^ self class formatName
]
