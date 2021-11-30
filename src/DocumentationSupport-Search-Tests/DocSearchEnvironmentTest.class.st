Class {
	#name : #DocSearchEnvironmentTest,
	#superclass : #TestCase,
	#instVars : [
		'docSearchEnv',
		'library',
		'chapters'
	],
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #running }
DocSearchEnvironmentTest >> setUp [
	super setUp.
	library := DocLibrary new.
	library addNewBook;
	addNewBook.
	library books first addNewChapter;
	addNewChapter.
	library books second addNewChapter.
	library books first chapters first title: 'chapitre 1'.
	library books first chapters second title: 'chapitre 2'.
	library books second chapters first title: 'chapitre 3'.
	library books first chapters first source: 'Eius populus ab incunabulis primis ad usque pueritiae tempus extremum, quod annis circumcluditur fere trecentis, circummurana pertulit bella, deinde aetatem ingressus adultam post multiplices bellorum aerumnas Alpes transcendit et fretum, in iuvenem erectus et virum ex omni plaga quam orbis ambit inmensus, reportavit laureas et triumphos, iamque vergens in senium et nomine solo aliquotiens vincens ad tranquilliora vitae discessit.'.
	library books first chapters second source: 'Constituendi autem sunt qui sint in amicitia fines et quasi termini diligendi. De quibus tres video sententias ferri, quarum nullam probo, unam, ut eodem modo erga amicum adfecti simus, quo erga nosmet ipsos, alteram, ut nostra in amicos benevolentia illorum erga nos benevolentiae pariter aequaliterque respondeat, tertiam, ut, quanti quisque se ipse facit, tanti fiat ab amicis.'.
	library books second chapters first source: 'Siquis enim militarium vel honoratorum aut nobilis inter suos rumore tenus esset insimulatus fovisse partes hostiles, iniecto onere catenarum in modum beluae trahebatur et inimico urgente vel nullo, quasi sufficiente hoc solo, quod nominatus esset aut delatus aut postulatus, capite vel multatione bonorum aut insulari solitudine damnabatur.'.
	chapters :=  library books flatCollect: [ :book | book chapters  ].
	
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentInitialize [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (OrderedCollection with: 1 with: chapters first source size - 1)).
	self assert: docSearchEnv ~= nil
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearch [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (OrderedCollection with: 1 with: chapters first source size - 1)).
	docSearchEnv search: 'lo'.
	self assert: docSearchEnv resultEntries size equals: 5.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 2'.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 3'.
	self assert: docSearchEnv resultEntries fifth chapter title equals: 'chapitre 3'.
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearchWithNothing [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (OrderedCollection with: 1 with: chapters first source size - 1)).
	docSearchEnv search: ''.
	self assert: docSearchEnv resultEntries size equals: 0
	
]
