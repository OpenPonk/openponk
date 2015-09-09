examples
example1
	| view class |
	view := RTView new.
	class := DCRTClass new
		stereotype: 'Kind';
		name: 'Object';
		attributes: #('-name: String[0..1]').
	class renderIn: view.
	view open.
	^ class