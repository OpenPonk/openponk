examples
example2
	| view class |
	view := RTView new.
	class := DCRTClass new
		name: 'Object';
		attributes: #('-name: String');
		methods: #('+setName(name: String)').
	class renderIn: view.
	view open.
	^ class