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
	book chapters first source: 'this is a text for the chapter 3 of the second book for tesTs'
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
	book chapters first source: 'This 13 is a test for the DocSearchEnvironment'.
	book chapters second title: 'chapitre 2'.
	book chapters second source: 'this is a text for the second chapter 440 of the first book for more Tests'
]

{ #category : #running }
DocSearchEnvironmentTest >> setUpChaptersOfThirdBook [
	| book |
	book := library books third.
	book chapters first title: 'chapitre 4'.
	book chapters first source: 'This is a test for 42 the DocSearchEnvironment in the third book of this test'.
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

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testFirstOccurenceOfFourthChapter [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	docSearchEnv firstOccurrenceOf: library books third chapters first.
	self assert: docSearchEnv currentEntryIndex equals: 2.
	self assert: docSearchEnv resultEntries size equals: 4.
	self assert: docSearchEnv currentResultEntry chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv currentResultEntry startPosition equals: 11
	
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testFirstOccurenceOfFourthChapterWithShiftedChapter [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: chapters fourth lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	docSearchEnv firstOccurrenceOf: library books third chapters first.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	self assert: docSearchEnv resultEntries size equals: 4.
	self assert: docSearchEnv currentResultEntry chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv currentResultEntry startPosition equals: 11
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testFirstOccurenceOfFourthChapterWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: false.
	docSearchEnv firstOccurrenceOf: library books third chapters first.
	self assert: docSearchEnv currentEntryIndex equals: 4.
	self assert: docSearchEnv resultEntries size equals: 6.
	self assert: docSearchEnv currentResultEntry chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv currentResultEntry startPosition equals: 11
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testFirstOccurenceOfFourthChapterWithoutSensitiveCaseWithShiftedChapters [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: chapters fourth lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: false.
	docSearchEnv firstOccurrenceOf: library books third chapters first.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	self assert: docSearchEnv resultEntries size equals: 6.
	self assert: docSearchEnv currentResultEntry chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv currentResultEntry startPosition equals: 11
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testFirstResultEntriesForEachChapter [
	| res |
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	res := docSearchEnv firstResultEntriesForEachChapters.
	self assert: res size equals: 3.
	self assert: res first chapter title  equals: 'chapitre 1'.
	self assert: res first startPosition  equals: 11.
	self assert: res second chapter title equals: 'chapitre 4'.
	self assert: res second startPosition equals: 11.
	self assert: res third chapter title equals: 'chapitre 5'.
	self assert: res third startPosition equals: 24
]

{ #category : #tests }
DocSearchEnvironmentTest >> testInitialize [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	self assert: docSearchEnv notNil
]

{ #category : #'tests-next' }
DocSearchEnvironmentTest >> testNextChapterInResultEntries [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	docSearchEnv nextChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 2.
	docSearchEnv nextChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 4
	
]

{ #category : #'tests-next' }
DocSearchEnvironmentTest >> testNextChapterInResultEntriesWhenCurrentEntryIndexIsLast [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	docSearchEnv currentEntryIndex: docSearchEnv resultEntries size.
	self assert: docSearchEnv currentEntryIndex equals: docSearchEnv resultEntries size.
	docSearchEnv nextChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 1
	
]

{ #category : #'tests-next' }
DocSearchEnvironmentTest >> testNextChapterInResultEntriesWithNoResultEntry [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: '' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 0.
	self assert: docSearchEnv currentEntryIndex equals: 0.
	docSearchEnv nextChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 0
	
]

{ #category : #'tests-next' }
DocSearchEnvironmentTest >> testNextChapterInResultEntriesWithOneResultEntry [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'third' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 1.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	docSearchEnv nextChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 1
	
]

{ #category : #'tests-next' }
DocSearchEnvironmentTest >> testNextResultEntry [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	docSearchEnv nextResultEntry.
	self assert: docSearchEnv currentEntryIndex equals: 2
	
]

{ #category : #'tests-next' }
DocSearchEnvironmentTest >> testNextResultEntryWhenCurrentEntryIndexIsLast [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	docSearchEnv currentEntryIndex: docSearchEnv resultEntries size.
	self assert: docSearchEnv currentEntryIndex equals: docSearchEnv resultEntries size.
	docSearchEnv nextResultEntry.
	self assert: docSearchEnv currentEntryIndex equals: 1
	
]

{ #category : #'tests-prev' }
DocSearchEnvironmentTest >> testPrevChapterInResultEntries [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	docSearchEnv prevChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 4.
	docSearchEnv prevChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 3
	
]

{ #category : #'tests-prev' }
DocSearchEnvironmentTest >> testPrevChapterInResultEntriesWithNoResultEntry [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: '' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 0.
	self assert: docSearchEnv currentEntryIndex equals: 0.
	docSearchEnv prevChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 0
]

{ #category : #'tests-prev' }
DocSearchEnvironmentTest >> testPrevChapterInResultEntriesWithOneResultEntry [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'third' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 1.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	docSearchEnv prevChapterInResultEntries.
	self assert: docSearchEnv currentEntryIndex equals: 1
	
]

{ #category : #'tests-prev' }
DocSearchEnvironmentTest >> testPrevResultEntry [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	docSearchEnv currentEntryIndex: 2.
	self assert: docSearchEnv currentEntryIndex equals: 2.
	docSearchEnv prevResultEntry.
	self assert: docSearchEnv currentEntryIndex equals: 1
	
]

{ #category : #'tests-prev' }
DocSearchEnvironmentTest >> testPrevResultEntryWhenCurrentEntryIndexIsFirst [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv currentEntryIndex equals: 1.
	docSearchEnv prevResultEntry.
	self assert: docSearchEnv currentEntryIndex equals: 4
	
]

{ #category : #tests }
DocSearchEnvironmentTest >> testResultEntriesOf [
	| res |
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	res := docSearchEnv resultEntriesOf: library books third chapters first key.
	self assert: res size equals: 2.
	self assert: res first chapter title  equals: 'chapitre 4'.
	self assert: res first startPosition  equals: 11.
	self assert: res second chapter title equals: 'chapitre 4'.
	self assert: res second startPosition equals: 71
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearch [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
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

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeBeginAt14 [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (14 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 3.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries second startPosition equals: 71.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries third startPosition equals: 24.
	
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeBeginAt14WithShiftedChapter [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (14 to: chapters fourth lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 3.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 71.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries second startPosition equals: 24.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries third startPosition equals: 11.

	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeBeginAt14WithShiftedChapterWithoutSensitiveCase [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (14 to: chapters fourth lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 5.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 71.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries second startPosition equals: 24.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries third startPosition equals: 11.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 2'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 66.
	self assert: docSearchEnv resultEntries fifth chapter title equals: 'chapitre 3'.
	self assert: docSearchEnv resultEntries fifth startPosition equals: 55.
	

	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeBeginAt14WithoutSensitiveCase [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (14 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 5.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 2'.
	self assert: docSearchEnv resultEntries first startPosition equals: 66.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 3'.
	self assert: docSearchEnv resultEntries second startPosition equals: 55.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries third startPosition equals: 11.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 71.
	self assert: docSearchEnv resultEntries fifth chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries fifth startPosition equals: 24.
	
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeFinishAt14 [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: 14)).
	docSearchEnv search: 'test' withSensitiveCase: true.
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

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeFinishAt14WithShiftedChapter [
	self skip.
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: 14)).
	docSearchEnv search: 'test'  withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 3.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 12.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries second startPosition equals: 25.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries third startPosition equals: 12.
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithDocSearchRangeFinishAt14WithoutSensitiveCase [
	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: 14)).
	docSearchEnv search: 'test' withSensitiveCase: false.
		self assert: docSearchEnv resultEntries size equals: 6.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 2'.
	self assert: docSearchEnv resultEntries second startPosition equals: 66.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 3'.
	self assert: docSearchEnv resultEntries third startPosition equals: 55.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 11.
	self assert: docSearchEnv resultEntries fifth chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries fifth startPosition equals: 71.
	self assert: docSearchEnv resultEntries sixth chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries sixth startPosition equals: 24.
	
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithNotDocSearchRange [

	docSearchEnv := DocSearchEnvironment new.
	self
		should: [ docSearchEnv search: 'dkhjsqokdjakl'  withSensitiveCase: true ]
		raise: Error
		withExceptionDo: [ :error | 
		self assert: error tag equals: #environmentNotSet ]
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithNotDocSearchRangeWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment new.
	self
		should: [ docSearchEnv search: 'dkhjsqokdjakl'  withSensitiveCase: false ]
		raise: Error
		withExceptionDo: [ :error | 
		self assert: error tag equals: #environmentNotSet ]
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithNotOccurence [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'dkhjsqokdjakl' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 0.
	
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithNotOccurenceWithShiftedChapter [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'dkhjsqokdjakl' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 0
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithNotOccurenceWithShiftedChapterWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'dkhjsqokdjakl' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 0
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithNotOccurenceWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'dkhjsqokdjakl' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 0
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithNothing [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: '' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 0.
	
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithNothingWhithShifted [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: '' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 0
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithNothingWhithShiftedWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.}  posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: '' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 0
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithNothingWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: '' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 0
]

{ #category : #'tests-sensitive-case' }
DocSearchEnvironmentTest >> testSearchWithShiftedChapter [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.} posInterval: (1 to: chapters fourth lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: true.
	self assert: docSearchEnv resultEntries size equals: 4.

	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries second  startPosition equals: 71.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries third startPosition equals: 24.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 11.
	
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithShiftedChapterWithouSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: {chapters fourth. chapters fifth. chapters first. chapters second. chapters third.} posInterval: (1 to: chapters fourth lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 6.

	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries second  startPosition equals: 71.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries third startPosition equals: 24.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 11.
	self assert: docSearchEnv resultEntries fifth chapter title equals: 'chapitre 2'.
	self assert: docSearchEnv resultEntries fifth startPosition equals: 66.
	self assert: docSearchEnv resultEntries sixth chapter title equals: 'chapitre 3'.
	self assert: docSearchEnv resultEntries sixth startPosition equals: 55.
]

{ #category : #'tests-search' }
DocSearchEnvironmentTest >> testSearchWithoutSensitiveCase [

	docSearchEnv := DocSearchEnvironment on:
		                (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	docSearchEnv search: 'test' withSensitiveCase: false.
	self assert: docSearchEnv resultEntries size equals: 6.
	self assert: docSearchEnv resultEntries first chapter title equals: 'chapitre 1'.
	self assert: docSearchEnv resultEntries first startPosition equals: 11.
	self assert: docSearchEnv resultEntries second chapter title equals: 'chapitre 2'.
	self assert: docSearchEnv resultEntries second startPosition equals: 66.
	self assert: docSearchEnv resultEntries third chapter title equals: 'chapitre 3'.
	self assert: docSearchEnv resultEntries third startPosition equals: 55.
	self assert: docSearchEnv resultEntries fourth chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries fourth startPosition equals: 11.
	self assert: docSearchEnv resultEntries fifth chapter title equals: 'chapitre 4'.
	self assert: docSearchEnv resultEntries fifth startPosition equals: 71.
	self assert: docSearchEnv resultEntries sixth chapter title equals: 'chapitre 5'.
	self assert: docSearchEnv resultEntries sixth startPosition equals: 24.
	
]
