Class {
	#name : 'OPProjectSaveCancellationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPProjectSaveCancellationTest >> testDefaultProjectFileNameUsesSanitizer [
	| project projectController |
	project := OPProject new.
	project name: 'Test: Invalid/Name?'.
	projectController := OPProjectController forProject: project.

	self
		assert: projectController defaultProjectFileName
		equals: (FileNameSanitizer sanitize: 'Test: Invalid/Name?') , '.opp'
]

{ #category : 'tests' }
OPProjectSaveCancellationTest >> testReplaceWritableProjectFileWhenAcceptedSetsStorageFile [
	| project projectController mockPresenter expectedFile |
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	expectedFile := 'mySavedProject.opp' asFileReference.

	mockPresenter := Mock new.
	StSaveFilePresenter stub new willReturn: mockPresenter.
	mockPresenter stub title: Any.
	mockPresenter stub extensions: Any named: Any.
	mockPresenter stub defaultFolder: Any.
	mockPresenter stub nameText: Any.
	mockPresenter stub openModal.
	mockPresenter stub cancelled willReturn: false.
	mockPresenter stub selectedEntry willReturn: expectedFile.

	self assert: projectController replaceWritableProjectFile equals: expectedFile.
	self assert: project storageFile equals: expectedFile
]

{ #category : 'tests' }
OPProjectSaveCancellationTest >> testReplaceWritableProjectFileWhenCanceledSignalsException [
	| project projectController mockPresenter |
	project := OPProject new.
	projectController := OPProjectController forProject: project.

	mockPresenter := Mock new.
	StSaveFilePresenter stub new willReturn: mockPresenter.
	mockPresenter stub title: Any.
	mockPresenter stub extensions: Any named: Any.
	mockPresenter stub defaultFolder: Any.
	mockPresenter stub nameText: Any.
	mockPresenter stub openModal.
	mockPresenter stub cancelled willReturn: true.
	mockPresenter stub selectedEntry willReturn: 'canceledProject.opp' asFileReference.

	self
		should: [ projectController replaceWritableProjectFile ]
		raise: OPProjectSaveCanceledException
]
