Class {
	#name : #OPExportCanvasDialog,
	#superclass : #FDSaveFileDialog,
	#category : #'OpenPonk-Spec'
}

{ #category : #actions }
OPExportCanvasDialog >> confirm [

	| file |
	file := self selectedEntry.
	file ifNil: [ ^ self ].

	self window close.
	onConfirmBlock value: file.
	self delete
]
