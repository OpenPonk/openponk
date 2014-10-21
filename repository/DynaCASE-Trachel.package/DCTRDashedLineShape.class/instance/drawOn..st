drawing
drawOn: athensCanvas
	athensCanvas pathTransform
		restoreAfter: [ 
			athensCanvas setShape: self path.
			(athensCanvas setStrokePaint: color)
				width: width;
				dashes: dashes offset: 0.
			athensCanvas draw ]