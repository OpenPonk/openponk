Extension { #name : #RTExampleBrowser }

{ #category : #'*OpenPonk-Roassal2' }
RTExampleBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	((aBuilder item: #Roassal) icon: RTIcon smallRoassal)
		withSeparatorAfter;
		order: 10;
		with: [ (aBuilder item: #'Roassal Examples')
				order: 0.1;
				parent: #Roassal;
				label: 'Roassal examples';
				help: 'Browse Roassal interactive examples';
				icon: RTIcon smallRoassal;
				action: [ self new open ] ]
]
