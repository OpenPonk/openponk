visualization
showLabelPositions: aDictionary
	| el |
	aDictionary
		keysAndValuesDo:
			[ :label :positions | 
			positions
				do:
					[ :each | 
					el := RTBox new
						color: Color transparent;
						borderColor: (Color red alpha: 0.5);
						borderStyle: #dash;
						width: each model width;
						height: each model height;
						elementOn: each index.
					el translateTo: each model center.
					view add: el.
					el @ RTLabelled new center ] ]