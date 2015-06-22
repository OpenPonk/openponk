grammar
multiplicity
	^ (($[ asParser , multiplicityRange , $] asParser) ==> [ :nodes | nodes second ]) optional