private
loadElementsFromController
	| timeToRun |
	timeToRun := [ [ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	diagramController rebuild.
	diagramController applyDefaultLayout ]
		ensure: [ World activeHand showTemporaryCursor: nil ] ] timeToRun.
	OPTelemetry current
		reportMetric:
			{#name -> 'diagram.rebuild'.
			#time -> timeToRun asMilliSeconds.
			#ctrlCount -> diagramController controllers size.
			#timeUnit -> 'ms'}
		plugin: diagramController plugin