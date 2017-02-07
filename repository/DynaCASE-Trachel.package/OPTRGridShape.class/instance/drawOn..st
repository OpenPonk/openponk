drawing
drawOn: athensCanvas
	athensCanvas pathTransform
		restoreAfter:
			[ 
			athensCanvas setShape: self path.
			(athensCanvas setStrokePaint: Color veryVeryLightGray) width: 1.
			athensCanvas draw ]