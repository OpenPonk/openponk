trachel shape production
contentGroupsFor: anElement
	| aColor height aContent lbl groups subGroup |
	aColor := self colorFor: anElement.
	height := TRLabelShape defaultFontSize.
	groups := RTGroup new.
	aContent := self contentFor: anElement.
	aContent ifNil: [ ^ groups ].
	aContent
		do: [ :aGroup | 
			subGroup := RTGroup new.
			aGroup
				do: [ :txt | 
					lbl := TRLabelShape new text: txt.
					lbl color: aColor.
					lbl fontSize: height.
					subGroup add: lbl ].
			RTVerticalLineLayout new
				verticalGap: 0;
				on: subGroup.
			groups add: subGroup ].
	^ groups