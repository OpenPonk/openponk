Class {
	#name : #OPDiagramsWriter,
	#superclass : #OPDiagramsPersistence,
	#category : #'OpenPonk-Spec-Views'
}

{ #category : #writing }
OPDiagramsWriter class >> persistViewsOf: aProject to: aFolder [
	^ self new persistViewsOf: aProject to: aFolder
]

{ #category : #writing }
OPDiagramsWriter >> persistViewsOf: aProject to: aFolder [
	| views |
	views := aProject diagrams.
	self halt.
	self write: (self serializeViewsInfo: views) to: aFolder.
	self writeViews: views to: aFolder
]

{ #category : #writing }
OPDiagramsWriter >> serializeViewsInfo: views [
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				mapInstVarsFor: OPDiagramInfo;
				nextPut: (views asArray collect: #asInfo) ]
]

{ #category : #writing }
OPDiagramsWriter >> write: aString to: aFileReference [
	aFileReference parent ensureCreateDirectory.
	aFileReference
		ensureDelete;
		writeStreamDo: [ :stream | stream << aString ]
]

{ #category : #writing }
OPDiagramsWriter >> writeViews: views to: aFolder [
	views
		do: [ :each | self write: each asJson to: (self fileNameForView: each sourceBase: aFolder) ]
]
