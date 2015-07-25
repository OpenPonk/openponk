example
example
	| c s eo |
	c := TRCanvas new.
	s := TRBoxShape new size: 50.
	s when: TRMouseLeftClick do: [ :evt |  ].
	c addShape: s.

	eo := DCTRAnnouncingOverseer new.
	c eventOverseer: eo.

	eo
		when: TRMouseLeftClick
		do: [ :event | 
			Transcript
				log: event;
				tab;
				logCr: event shape ].

	c open