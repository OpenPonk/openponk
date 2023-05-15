Class {
	#name : #OPExportInfo,
	#superclass : #Object,
	#instVars : [
		'subject',
		'version',
		'format'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPExportInfo class >> fileName [

	^ 'export-info.json'
]

{ #category : #accessing }
OPExportInfo class >> neoJsonMapping: mapper [

	mapper for: self do: [ :mapping | mapping mapAllInstVars ]
]

{ #category : #accessing }
OPExportInfo >> format [

	^ format
]

{ #category : #accessing }
OPExportInfo >> format: anObject [

	format := anObject
]

{ #category : #accessing }
OPExportInfo >> subject [

	^ subject
]

{ #category : #accessing }
OPExportInfo >> subject: anObject [

	subject := anObject
]

{ #category : #accessing }
OPExportInfo >> version [

	^ version
]

{ #category : #accessing }
OPExportInfo >> version: anObject [

	version := anObject
]
