"
Verifies that entry completion chooser popups calculate their screen position from world coordinates rather than local container coordinates, preventing misplaced completion menus when text fields are embedded in nested presenters.
"
Class {
	#name : 'OPEntryCompletionTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPEntryCompletionTest >> testChooserPositionUsesWorldCoordinates [
	| containerMorph fieldMorph entryCompletion chooserMorph expectedPosition |
	containerMorph := TransformMorph new.
	containerMorph position: 300 @ 200; extent: 400 @ 300.
	fieldMorph := RubTextFieldMorph new.
	fieldMorph position: 10 @ 50; extent: 200 @ 30.
	containerMorph addMorph: fieldMorph.

	entryCompletion := EntryCompletion new.
	entryCompletion dataSourceBlock: [ :token | #( 'Order' 'OrderItem' ) ].
	fieldMorph entryCompletion: entryCompletion.

	[
		containerMorph openInWorld.
		self currentWorld doOneCycle.

		chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
		self assert: chooserMorph isNotNil.

		expectedPosition := fieldMorph boundsInWorld bottomLeft + (fieldMorph borderWidth @ 0).

		self assert: chooserMorph position equals: expectedPosition
	] ensure: [
		entryCompletion closeChooser.
		containerMorph delete ]
]
