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
	containerMorph position: 20 @ 20; extent: 200 @ 150.
	fieldMorph := RubTextFieldMorph new.
	fieldMorph position: 10 @ 20; extent: 150 @ 25.
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

{ #category : 'tests' }
OPEntryCompletionTest >> testOpenChooserClampsHeightWhenExceedingAllowedArea [
	| containerMorph fieldMorph entryCompletion chooserMorph allowedAreaBottom |
	containerMorph := TransformMorph new.
	allowedAreaBottom := (RealEstateAgent maximumUsableAreaInWorld: self currentWorld) bottom.
	containerMorph position: 10 @ (allowedAreaBottom - 60); extent: 200 @ 80.
	fieldMorph := RubTextFieldMorph new.
	fieldMorph position: 10 @ 10; extent: 150 @ 25.
	containerMorph addMorph: fieldMorph.

	entryCompletion := EntryCompletion new.
	entryCompletion dataSourceBlock: [ :token | #( 'Order' 'OrderItem' 'OrderLine' 'OrderHistory' ) ].
	fieldMorph entryCompletion: entryCompletion.

	[
		containerMorph openInWorld.
		self currentWorld doOneCycle.

		chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
		self assert: chooserMorph isNotNil.
		self assert: chooserMorph boundsInWorld bottomLeft y <= chooserMorph allowedArea bottom
	] ensure: [
		entryCompletion closeChooser.
		containerMorph delete ]
]
