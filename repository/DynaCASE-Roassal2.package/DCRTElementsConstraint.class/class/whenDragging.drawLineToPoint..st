public - visualization
whenDragging: aShape drawLineToPoint: aBlock
	| lineTargetBox dynamicLine |
	aShape
		when: TRMouseDragStart
			do: [ 
					(lineTargetBox := RTBox new
						size: 0;
						color: Color transparent;
						element) translateTo: aBlock value.
					aShape view
						add: lineTargetBox;
						add: (dynamicLine := (RTLine new color: Color veryLightGray) edgeFrom: lineTargetBox to: aShape);
						signalUpdate ];
		when: TRMouseDragging do: [ lineTargetBox translateTo: aBlock value ];
		when: TRMouseDragEnd
			do: [ 
					dynamicLine remove.
					lineTargetBox remove.
					dynamicLine := lineTargetBox := nil.
					aShape view signalUpdate ]