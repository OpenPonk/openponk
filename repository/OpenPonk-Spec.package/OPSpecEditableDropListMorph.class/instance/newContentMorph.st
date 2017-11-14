instance creation
newContentMorph
	"Answer a new content morph"

	| pt |
	pt := super newContentMorph.
	pt vResizing: #spaceFill.
	pt textMorph
		autoFit: true;
		wrapFlag: false;
		margins:
			(Margin
				left: 5
				top: -2
				right: 0
				bottom: 0).
	^ pt