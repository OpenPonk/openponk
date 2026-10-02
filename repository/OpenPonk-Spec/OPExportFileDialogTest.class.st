"
Validates modal dialog configuration, lazy content generation, and file writing during file export.
"
Class {
	#name : 'OPExportFileDialogTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPExportFileDialogTest >> testExportBlockExecutedWhenFileSelected [
	| mockPresenter executed tempFile storedAction |
	executed := false.
	tempFile := FileSystem memory root / 'test.txt'.

	mockPresenter := Mock new.
	StSaveFilePresenter stub new willReturn: mockPresenter.
	mockPresenter stub title: Any.
	mockPresenter stub extensions: Any named: Any.
	mockPresenter stub nameText: Any.
	(mockPresenter stub okAction: Any) will: [ :action |
		storedAction := action isBlock
			ifTrue: [ action ]
			ifFalse: [
				(action respondsTo: #arguments)
					ifTrue: [ action arguments first ]
					ifFalse: [ action ] ] ].
	mockPresenter stub openModal will: [ storedAction value: tempFile ].

	[
		[
			OPExportFileDialog
				exportBlock: [ executed := true. 'sample content' ]
				defaultFileName: 'test.txt'
				extensions: #( txt )
				named: 'Text files'
				title: 'Export Text'
		] on: ProvideAnswerNotification do: [ :notification | notification resume: true ].

		self assert: executed description: 'Export block must be executed when file is chosen'.
		self assert: tempFile exists description: 'Export file must be created'.
		self assert: tempFile contents equals: 'sample content'
	] ensure: [ tempFile ensureDelete ]
]

{ #category : 'tests' }
OPExportFileDialogTest >> testExportBlockNotExecutedWhenDialogCanceled [
	| mockPresenter executed |
	executed := false.

	mockPresenter := Mock new.
	StSaveFilePresenter stub new willReturn: mockPresenter.
	mockPresenter stub title: Any.
	mockPresenter stub extensions: Any named: Any.
	mockPresenter stub nameText: Any.
	mockPresenter stub okAction: Any.
	mockPresenter stub openModal.

	[
		OPExportFileDialog
			exportBlock: [ executed := true. 'sample content' ]
			defaultFileName: 'test.txt'
			extensions: #( txt )
			named: 'Text files'
			title: 'Export Text'
	] on: ProvideAnswerNotification do: [ :notification | notification resume: true ].

	self deny: executed description: 'Export block must not be executed when dialog is dismissed without confirmation'
]
