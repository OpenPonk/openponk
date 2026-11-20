"
Verifies that entry completion chooser popups calculate their screen position from world coordinates rather than local container coordinates, preventing misplaced completion menus when text fields are embedded in nested presenters.
"
Class {
	#name : 'OPEntryCompletionTest',
	#superclass : 'OPAbstractUITest',
	#category : 'OpenPonk-Spec-Tests-Form',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Form'
}

{ #category : 'private' }
OPEntryCompletionTest >> assertChooser: aChooserMorph flippedAboveField: aFieldMorph [

	self assert: aChooserMorph class identicalTo: IdentifierChooserMorph.
	self
		assert: aChooserMorph fullBounds bottom <= aFieldMorph boundsInWorld topLeft y
		description: 'Chooser must flip above field morph when bottom space is insufficient'.
	self
		assert: aChooserMorph fullBounds top >= aChooserMorph allowedArea top
		description: 'Flipped chooser top edge must remain within allowed usable world area'.
	self assert: aChooserMorph boundsInWorld left equals: aFieldMorph boundsInWorld topLeft x + aFieldMorph borderWidth
]

{ #category : 'tests' }
OPEntryCompletionTest >> testChooserPositionUsesWorldCoordinates [

	| containerMorph fieldMorph entryCompletion chooserMorph expectedPosition |
	containerMorph := TransformMorph new.
	containerMorph
		position: 20 @ 20;
		extent: 200 @ 150.
	fieldMorph := RubTextFieldMorph new.
	fieldMorph
		position: 10 @ 20;
		extent: 150 @ 25.
	containerMorph addMorph: fieldMorph.

	entryCompletion := EntryCompletion new.
	entryCompletion dataSourceBlock: [ :token | #( 'Order' 'OrderItem' ) ].
	fieldMorph entryCompletion: entryCompletion.

	[
		containerMorph openInWorld.
		self currentWorld doOneCycle.

		chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
		self assert: chooserMorph class identicalTo: IdentifierChooserMorph.

		expectedPosition := fieldMorph boundsInWorld bottomLeft + (fieldMorph borderWidth @ 0).

		self assert: chooserMorph position equals: expectedPosition ] ensure: [
			entryCompletion closeChooser.
			containerMorph delete ]
]

{ #category : 'tests' }
OPEntryCompletionTest >> testOpenChooserClampsHeightWhenExceedingAllowedArea [

	| containerMorph fieldMorph entryCompletion chooserMorph allowedAreaBottom |
	containerMorph := TransformMorph new.
	allowedAreaBottom := (RealEstateAgent maximumUsableAreaInWorld: self currentWorld) bottom.
	containerMorph
		position: 10 @ (allowedAreaBottom - 60);
		extent: 200 @ 80.
	fieldMorph := RubTextFieldMorph new.
	fieldMorph
		position: 10 @ 10;
		extent: 150 @ 25.
	containerMorph addMorph: fieldMorph.

	entryCompletion := EntryCompletion new.
	entryCompletion dataSourceBlock: [ :token | #( 'Order' 'OrderItem' 'OrderLine' 'OrderHistory' ) ].
	fieldMorph entryCompletion: entryCompletion.

	[
		containerMorph openInWorld.
		self currentWorld doOneCycle.

		chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
		self assert: chooserMorph class identicalTo: IdentifierChooserMorph.
		self
			assert: chooserMorph boundsInWorld bottomLeft y <= chooserMorph allowedArea bottom
			description: 'Chooser bottom edge must be clamped within the allowed usable world area'.
		self currentWorld doOneCycle.
		self
			assert: chooserMorph boundsInWorld bottomLeft y <= chooserMorph allowedArea bottom
			description: 'Chooser bottom edge must remain clamped within the allowed usable world area after layout cycle'.
		self
			assert: chooserMorph fullBounds bottom <= chooserMorph allowedArea bottom
			description: 'Chooser fullBounds bottom edge must remain clamped within the allowed usable world area' ] ensure: [
			entryCompletion closeChooser.
			containerMorph delete ]
]

{ #category : 'tests' }
OPEntryCompletionTest >> testOpenChooserClosesWhenNeitherBottomNorTopFitsContent [

	self
		withEntryCompletionFixtureWithBottomSpace: 100
		labels: #( 'Order' 'OrderItem' 'OrderLine' 'OrderHistory' )
		do: [ :fieldMorph :entryCompletion |
				| fieldBounds restrictedArea chooserMorph |
				fieldBounds := fieldMorph boundsInWorld.
				restrictedArea := 0 @ (fieldBounds top - 2) corner: fieldBounds right + 200 @ (fieldBounds bottom + 2).
				(RealEstateAgent stub maximumUsableAreaInWorld: self currentWorld) willReturn: restrictedArea.
				[
					chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
					self assert: chooserMorph identicalTo: nil.
					self assert: entryCompletion chooser identicalTo: nil ] ensure: [ RealEstateAgent recoverFromGHMutation ] ]
]

{ #category : 'tests' }
OPEntryCompletionTest >> testOpenChooserFlipsAboveAndClampsHeightWhenAboveSpaceAlsoExceeded [

	self
		withEntryCompletionFixtureWithBottomSpace: 100
		labels: #( 'Order' 'OrderItem' 'OrderLine' 'OrderHistory' )
		do: [ :fieldMorph :entryCompletion |
				| fieldBounds restrictedArea chooserMorph |
				fieldBounds := fieldMorph boundsInWorld.
				restrictedArea := 0 @ (fieldBounds top - 40) corner: fieldBounds right + 200 @ (fieldBounds bottom + 1).
				(RealEstateAgent stub maximumUsableAreaInWorld: self currentWorld) willReturn: restrictedArea.
				[
					chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
					self assertChooser: chooserMorph flippedAboveField: fieldMorph.
					self currentWorld doOneCycle.
					self assertChooser: chooserMorph flippedAboveField: fieldMorph ] ensure: [ RealEstateAgent recoverFromGHMutation ] ]
]

{ #category : 'tests' }
OPEntryCompletionTest >> testOpenChooserFlipsAboveWhenBottomSpaceIsAtMostBorderWidth [

	self
		withEntryCompletionFixtureWithBottomSpace: 2
		labels: #( 'Order' 'OrderItem' 'OrderLine' 'OrderHistory' )
		do: [ :fieldMorph :entryCompletion |
				| chooserMorph |
				chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
				self assertChooser: chooserMorph flippedAboveField: fieldMorph.
				self currentWorld doOneCycle.
				self assertChooser: chooserMorph flippedAboveField: fieldMorph ]
]

{ #category : 'tests' }
OPEntryCompletionTest >> testOpenChooserFlipsAboveWhenBottomSpaceIsSmallerThanOneItem [

	self
		withEntryCompletionFixtureWithBottomSpace: 8
		labels: #( 'Order' 'OrderItem' 'OrderLine' 'OrderHistory' )
		do: [ :fieldMorph :entryCompletion |
				| chooserMorph |
				chooserMorph := entryCompletion openChooserWith: 'Or' from: fieldMorph.
				self assertChooser: chooserMorph flippedAboveField: fieldMorph.
				self currentWorld doOneCycle.
				self assertChooser: chooserMorph flippedAboveField: fieldMorph ]
]

{ #category : 'private' }
OPEntryCompletionTest >> withEntryCompletionFixtureWithBottomSpace: aBottomSpace labels: aLabelCollection do: aBlock [

	| allowedAreaBottom containerMorph fieldMorph entryCompletion targetBottom |
	allowedAreaBottom := (RealEstateAgent maximumUsableAreaInWorld: self currentWorld) bottom.
	containerMorph := TransformMorph new.
	containerMorph
		position: 10 @ (allowedAreaBottom - 60);
		extent: 200 @ 80.
	fieldMorph := RubTextFieldMorph new.
	fieldMorph
		position: 10 @ 10;
		extent: 150 @ 25.
	containerMorph addMorph: fieldMorph.

	entryCompletion := EntryCompletion new.
	entryCompletion dataSourceBlock: [ :token | aLabelCollection ].
	fieldMorph entryCompletion: entryCompletion.

	[
		containerMorph openInWorld.
		self currentWorld doOneCycle.
		targetBottom := allowedAreaBottom - aBottomSpace.
		containerMorph position: 10 @ (targetBottom - fieldMorph fullBounds height - 10).
		self currentWorld doOneCycle.
		aBlock value: fieldMorph value: entryCompletion ] ensure: [
			entryCompletion closeChooser.
			containerMorph delete ]
]
