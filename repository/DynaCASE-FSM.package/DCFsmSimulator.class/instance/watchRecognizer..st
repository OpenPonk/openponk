events
watchRecognizer: aRecognizer
	aRecognizer
		when: DCFsmRecognizerEvent
		do: [ :ann | 
			aRecognizer isInputEmpty
				ifFalse: [ nextButton enable ].
			aRecognizer isPathEmpty
				ifFalse: [ backButton enable ] ].

	aRecognizer
		when: DCFsmRecognizerSuccess
		do: [ :ann | DCFsmFigureHighlighter highlightElement: (diagramController figureFor: ann place) with: Color green ].

	aRecognizer
		when: DCFsmRecognizerFailure
		do: [ :ann | DCFsmFigureHighlighter highlightElement: (diagramController figureFor: ann place) with: Color red ].

	aRecognizer
		when: DCFsmRecognizerLeave
		do: [ :ann | DCFsmFigureHighlighter unhighlight: (diagramController figureFor: ann place) ].

	aRecognizer
		when: DCFsmRecognizerEnter
		do: [ :ann | DCFsmFigureHighlighter highlight: (diagramController figureFor: ann place) with: Color orange ]