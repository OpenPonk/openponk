Class {
	#name : 'OPPanedLayoutPatch',
	#superclass : 'Object',
	#category : 'OpenPonk-Morphic-Morphic',
	#package : 'OpenPonk-Morphic',
	#tag : 'Morphic'
}

{ #category : 'applying' }
OPPanedLayoutPatch class >> apply [
	(SpMorphicPanedLayout includesSelector: #isFromEnd) ifTrue: [ ^ self ].

	self applyLayoutPolicyChanges.
	self applyResizerChanges
]

{ #category : 'applying' }
OPPanedLayoutPatch class >> applyLayoutPolicyChanges [
	TableLayout << #SpMorphicPanedLayout
		layout: FixedLayout;
		slots: { #position. #isResizing };
		sharedVariables: {  };
		package: 'Spec2-Adapters-Morphic';
		tag: 'Layout';
		install.

	SpMorphicPanedLayout compile: 'isFromEnd
		^ self position isNotNil and: [ self position < 0 ]' classified: 'testing'.

	SpMorphicPanedLayout compile: 'isFixed
		^ self position isNotNil and: [ self position abs >= 1 ]' classified: 'testing'.

	SpMorphicPanedLayout compile: 'isResizing
		^ isResizing ifNil: [ false ]' classified: 'testing'.

	SpMorphicPanedLayout compile: 'position: anObject
		position := anObject.
		isResizing := false' classified: 'accessing'.

	SpMorphicPanedLayout compile: 'resetPosition
		"Flag that splitter dragging is active so intermediate relayout passes do not override manual adjustment."
		isResizing := true' classified: 'actions'.

	SpMorphicPanedLayout compile: 'widthPositionIn: aPoint
		self position ifNil: [ ^ (aPoint x * 0.5) asInteger ].
		self isFixed ifTrue: [ ^ self position abs asInteger ].
		^ (aPoint x * self position abs) asInteger' classified: 'private'.

	SpMorphicPanedLayout compile: 'heightPositionIn: aPoint
		self position ifNil: [ ^ (aPoint y * 0.5) asInteger ].
		self isFixed ifTrue: [ ^ self position abs asInteger ].
		^ (aPoint y * self position abs) asInteger' classified: 'private'.

	SpMorphicPanedLayout compile: 'ensureWidthPosition: aMorph in: aRect
		| targetMorph otherMorph width |
		self position ifNil: [ ^ self ].
		self isResizing ifTrue: [ ^ self ].
		aMorph submorphs size < 3 ifTrue: [ ^ self ].

		targetMorph := self isFromEnd
			ifTrue: [ aMorph submorphs last ]
			ifFalse: [ aMorph submorphs first ].
		otherMorph := self isFromEnd
			ifTrue: [ aMorph submorphs first ]
			ifFalse: [ aMorph submorphs last ].

		targetMorph hResizing = #rigid ifFalse: [ targetMorph hResizing: #rigid ].
		otherMorph hResizing = #spaceFill ifFalse: [ otherMorph hResizing: #spaceFill ].

		width := self widthPositionIn: aRect extent.
		targetMorph width = width ifFalse: [ targetMorph width: width ]' classified: 'private'.

	SpMorphicPanedLayout compile: 'ensureHeightPosition: aMorph in: aRect
		| targetMorph otherMorph height |
		self position ifNil: [ ^ self ].
		self isResizing ifTrue: [ ^ self ].
		aMorph submorphs size < 3 ifTrue: [ ^ self ].

		targetMorph := self isFromEnd
			ifTrue: [ aMorph submorphs last ]
			ifFalse: [ aMorph submorphs first ].
		otherMorph := self isFromEnd
			ifTrue: [ aMorph submorphs first ]
			ifFalse: [ aMorph submorphs last ].

		targetMorph vResizing = #rigid ifFalse: [ targetMorph vResizing: #rigid ].
		otherMorph vResizing = #spaceFill ifFalse: [ otherMorph vResizing: #spaceFill ].

		height := self heightPositionIn: aRect extent.
		targetMorph height = height ifFalse: [ targetMorph height: height ]' classified: 'private'.

	SpMorphicPanedLayout compile: 'computePreservedPositionOn: layoutedMorph
		| targetMorph newDimension delta |
		targetMorph := self isFromEnd
			ifTrue: [ layoutedMorph submorphs last ]
			ifFalse: [ layoutedMorph submorphs first ].

		newDimension := self isHorizontal
			ifTrue: [ targetMorph width ]
			ifFalse: [ targetMorph height ].

		self isFixed ifTrue: [
			^ self isFromEnd
				ifTrue: [ newDimension asInteger negated ]
				ifFalse: [ newDimension asInteger ] ].

		delta := self isHorizontal
			ifTrue: [ (newDimension * 100 / layoutedMorph width) asInteger percent ]
			ifFalse: [ (newDimension * 100 / layoutedMorph height) asInteger percent ].

		^ self isFromEnd
			ifTrue: [ delta negated ]
			ifFalse: [ delta ]' classified: 'private'.

	SpMorphicPanedLayout compile: 'preservePositionProportionOn: layoutedMorph
		isResizing := false.
		layoutedMorph submorphs size < 3 ifTrue: [ ^ self ].
		position := self computePreservedPositionOn: layoutedMorph.
		layoutedMorph layoutChanged' classified: 'actions'
]

{ #category : 'applying' }
OPPanedLayoutPatch class >> applyResizerChanges [
	LayoutPolicy compile: 'isFromEnd
		^ false' classified: '*Spec2-Adapters-Morphic'.

	SpPanedResizerMorph compile: 'isFromEnd
		^ self owner
			ifNotNil: [ :ownerMorph |
				ownerMorph layoutPolicy
					ifNotNil: [ :layoutPolicy | layoutPolicy isFromEnd ] ]
			ifNil: [ false ]' classified: 'testing'.

	SpPanedResizerHorizontalMorph compile: 'setTargetLayoutSizing
		self isFromEnd
			ifTrue: [
				self targetAfter hResizing = #rigid ifTrue: [ ^ self ].
				self targetAfter hResizing: #rigid.
				self target hResizing: #spaceFill ]
			ifFalse: [
				self target hResizing = #rigid ifTrue: [ ^ self ].
				self target hResizing: #rigid.
				self targetAfter hResizing: #spaceFill ]' classified: 'private'.

	SpPanedResizerHorizontalMorph compile: 'setTargetBounds
		self target ifNotNil: [ :targetMorph |
			targetMorph bounds: (targetMorph bounds withRight: self left) ].
		self targetAfter ifNotNil: [ :targetAfterMorph |
			targetAfterMorph bounds: (self right @ targetAfterMorph top corner: targetAfterMorph bottomRight) ]' classified: 'private'.

	SpPanedResizerVerticalMorph compile: 'setTargetLayoutSizing
		self isFromEnd
			ifTrue: [
				self targetAfter vResizing = #rigid ifTrue: [ ^ self ].
				self targetAfter vResizing: #rigid.
				self target vResizing: #spaceFill ]
			ifFalse: [
				self target vResizing = #rigid ifTrue: [ ^ self ].
				self target vResizing: #rigid.
				self targetAfter vResizing: #spaceFill ]' classified: 'private'.

	SpPanedResizerVerticalMorph compile: 'setTargetBounds
		self target ifNotNil: [ :targetMorph |
			targetMorph bounds: (targetMorph position corner: (targetMorph right @ self top)) ].
		self targetAfter ifNotNil: [ :targetAfterMorph |
			targetAfterMorph bounds: (targetAfterMorph left @ self bottom corner: targetAfterMorph bottomRight) ]' classified: 'private'
]
