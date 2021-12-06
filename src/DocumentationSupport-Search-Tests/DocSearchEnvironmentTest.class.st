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
	self setUpLibrary.
	
	
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpChapterOfSecondBook [
	| book |
	book :=library books second. 
	book chapters first title: 'chapitre 3'.
	book chapters first source: 'this is a text for the chapter of the second book'
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpChapters [
	library books first addNewChapter;
	addNewChapter.
	library books second addNewChapter.
	library books third addNewChapter;
	addNewChapter.
	self setUpChaptersOfFirstBook.
	self setUpChapterOfSecondBook.
	self setUpChaptersOfThirdBook
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpChaptersOfFirstBook [
	| book |
	book := library books first.
	book chapters first title: 'chapitre 1'.
	book chapters first source: 'This is a test for the DocSearchEnvironment'.
	book chapters second title: 'chapitre 2'.
	book chapters second source: 'this is a text for the second chapter of the first book'
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpChaptersOfThirdBook [
	| book |
	book := library books third.
	book chapters first title: 'chapitre 4'.
	book chapters first source: 'This is a test for the DocSearchEnvironment in the third book of this test'.
	book chapters second title: 'chapitre 5'.
	book chapters second source: 'this is a text for the tests of DocSearchEnvironment'
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpLibrary [
	self setUpThreeBooks.
	self setUpChapters.
	chapters :=  library books flatCollect: [ :book | book chapters  ].
	
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpThreeBooks [
	library addNewBook;
	addNewBook;
	addNewBook.
	library books first title: 'Books 1'.
	library books second title: 'Books 2'.
	library books third title: 'Books 3'
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentInitialize [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	self assert: docSearchEnv notNil
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearch [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test'.
	self assert: docSearchEnv resultEntries size equals: 4.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries second startPosition equals: 11.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries third startPosition equals: 71.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 24.
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearchWithDocSearchRangeBeginAt14 [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (14 to: chapters first lastPosition)).
	docSearchEnv search: 'test'.
	self assert: docSearchEnv resultEntries size equals: 3.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries second startPosition equals: 71.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries third startPosition equals: 24.
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearchWithNotDocSearchRange [

	docSearchEnv := DocSearchEnvironment new.
	self should: [docSearchEnv search: 'dkhjsqokdjakl'] raise: MessageNotUnderstood.
	

]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearchWithNotOccurence [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'dkhjsqokdjakl'.
	self assert: docSearchEnv resultEntries size equals: 0
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testDocSearchEnvironmentSearchWithNothing [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: ''.
	self assert: docSearchEnv resultEntries size equals: 0
	
]
