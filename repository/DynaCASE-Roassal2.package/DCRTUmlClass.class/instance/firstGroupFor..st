trachel shape production
firstGroupFor: anElement
	| aColor height group |
	aColor := self colorFor: anElement.
	height := TRLabelShape defaultFontSize.

	group := RTGroup new.

	"stereotype"
	stereotype
		ifNotNil: [ 
			group
				add:
					(TRLabelShape new
						text: (self stereotypeFor: anElement);
						color: aColor;
						fontSize: height - 1) ].

	"class name"
	group
		add:
			(TRLabelShape new
				text: (self nameFor: anElement);
				color: aColor;
				fontSize: height + 1).
	RTVerticalLineLayout new
		verticalGap: 0;
		on: group.

	^ group