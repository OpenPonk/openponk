Extension { #name : 'StDirectoryTreePresenter' }

{ #category : '*OpenPonk-Core' }
StDirectoryTreePresenter >> expandPath: aFileLocator [
	"Expand the receiver's tree to aFileLocator reference"

	| path aPathForSpec currentNode |
	self flag: 'Remove (replace by NewTools version) in Pharo 13'.
	path := aFileLocator absolutePath segments asOrderedCollection.
	aPathForSpec := OrderedCollection with: 1.

	currentNode := directoryTreePresenter roots anyOne.
	Smalltalk os isWindows ifTrue: [
		currentNode := currentNode asFileReference parent.
		aPathForSpec := OrderedCollection new ].

	path do: [ :aPart |
		| subdirs |
		subdirs := currentNode directories sorted: [ :a :b |
			           a basename caseInsensitiveLessOrEqual: b basename ].
		currentNode := nil.
		subdirs doWithIndex: [ :subdir :index |
			(currentNode isNil and: [ subdir basename = aPart ]) ifTrue: [
				currentNode := subdir.
				aPathForSpec add: index ] ].
		currentNode ifNil: [ ^ self ] ].

	directoryTreePresenter
		selectPath: aPathForSpec
		scrollToSelection: true.

	"The Morphic `configureScrolling` is executed **AFTER** the desired scroll was configured from the `StDirectoryTreePresenter`. Furthermore, the `configureScrolling` uses the `desiredVisibleRow` which is always set to 1. This statement updates the desired visible row to the last visible index of whatever the selection is pointing to."

	directoryTreePresenter verticalAlignment lastVisibleRowIndex ifNil: [
		^ self ].
	directoryTreePresenter verticalAlignment desiredVisibleRow:
		directoryTreePresenter verticalAlignment lastVisibleRowIndex
]
