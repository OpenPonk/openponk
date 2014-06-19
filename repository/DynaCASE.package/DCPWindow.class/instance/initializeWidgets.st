as yet unclassified
initializeWidgets

    view := DCPDrawing new asSpecAdapter.
    button1 := self newButton.
    button2 := self newDropList .
    button2 addItemLabeled: 'UML' do: [ button1 label: 'UML Class'.].
    button2 addItemLabeled: 'Petri' do: [ button1 label: 'Petri state'.].
    button2 setSelectedIndex: 1.

	

    self focusOrder
        add: button1;
        add: button2.