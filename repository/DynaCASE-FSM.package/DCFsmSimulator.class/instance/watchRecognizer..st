events
watchRecognizer: aRecognizer
	aRecognizer
		when: DCFsmStateCompleted
		do: [ :ann | 
			self stopAction.
			aRecognizer accepts
				ifTrue: [ DCFsmFigureHighlighter highlightElement: (diagramController figureFor: ann state) with: Color green ] ].

	aRecognizer when: DCFsmRecognizerStepCompleted do: [ :ann | step enable ].

	aRecognizer
		when: DCFsmSymbolReached
		do: [ :ann | 
			self remainderLabel: aRecognizer remainder.
			self symbolLabel: ann symbol ].

	aRecognizer
		when: DCFsmTransitionDeparted
		do: [ :ann | DCFsmFigureHighlighter unhighlightEdge: (diagramController figureFor: ann transition) ].
	aRecognizer
		when: DCFsmTransitionReached
		do: [ :ann | DCFsmFigureHighlighter highlightEdge: (diagramController figureFor: ann transition) ].

	aRecognizer
		when: DCFsmStateDeparted
		do: [ :ann | DCFsmFigureHighlighter unhighlightElement: (diagramController figureFor: ann state) ].
	aRecognizer
		when: DCFsmStateReached
		do: [ :ann | 
			DCFsmFigureHighlighter highlightElement: (diagramController figureFor: ann state).
			DCFsmFigureHighlighter unhighlightEdge: (diagramController figureFor: ann transition) ]