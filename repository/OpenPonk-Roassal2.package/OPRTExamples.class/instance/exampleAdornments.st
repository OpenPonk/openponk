sources
exampleAdornments
|v el|
v := RTView new.

el := RTBox new
	size: 100;
	element.
v add: el.
el
	@
		(OPRTAdornments new
			adornments:
				{#testNotRun asIcon
					-> [ el color: Color veryVeryLightGray.
						v signalUpdate ].
				#testGreen asIcon
					-> [ el color: Color green.
						v signalUpdate ].
				#testRed asIcon
					-> [ el color: Color red.
						v signalUpdate ]}).
el when: TRMouseLeftClick do: [ :evt | el announce: OPTRFocused new ].
v when: TRMouseLeftClick do: [ :evt | el announce: OPTRUnfocused new ].

^ v