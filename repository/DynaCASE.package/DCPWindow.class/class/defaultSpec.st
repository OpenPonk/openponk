as yet unclassified
defaultSpec
	<spec: #default>
	^ SpecLayout composed
	newColumn: [ :windowcol | windowcol
		newRow: [ :topmenu | topmenu 
			add: #button1; 
			add: #button1; 
			add: #button1; 
			add: #button1; 
			add: #button1.
			] height: 40;
		newRow: [ :mainarea | mainarea
			 newColumn: [ :surface |
			  	surface add: #viewMorph ];
			 newColumn: [ :sidepanel | 
				sidepanel add: #button2; 
				add: #button2; 
				add: #button2; 
				add: #button2; 
				add: #button2; 
				add: #button2; 
				add: #button2.
				] width: 150
			]
		];yourself.