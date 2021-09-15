Class {
	#name : #SearchBookTest,
	#superclass : #TestCase,
	#instVars : [
		'searchObject',
		'library'
	],
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #running }
SearchBookTest >> setUp [
	super setUp.
	searchObject := SearchBook new.
	library := DocLibrary new.
	library addNewBook;
	addNewBook.
	library books first addNewChapter;
	addNewChapter;
	addNewChapter.
	library books second addNewChapter;
	addNewChapter.
	library books first chapters first source: 'this test is a test'.
	library books first chapters second source: 'test'.
	library books second chapters second source: 'test'.
]

{ #category : #tests }
SearchBookTest >> testIndexOfBooks [
	| library dictionary |
	library := DocLibrary new.
	library addNewBook.
	library books first	addNewChapter;
	addNewChapter;
	addNewChapter.
	dictionary := searchObject indexOfBooks:  'test' in: library .
	self assert: dictionary size equals: 1.
	self assert: dictionary values first size equals: 3
	
]

{ #category : #tests }
SearchBookTest >> testIndexOfChapters [
	| book |
	book := DocBook new.
	book setLibrary: DocLibrary new;
	addNewChapter;
	addNewChapter;
	addNewChapter.
	(book chapters at: 2) title: 'test'.
	self assert: (searchObject indexOfChapters:  'test' in: book ) size equals: 3
	
]

{ #category : #tests }
SearchBookTest >> testIndexOfSubstring [

	self assert: (searchObject indexOfSubstring: 'test' in: 'test other test word') equals: #(1 12) asOrderedCollection
	
]

{ #category : #tests }
SearchBookTest >> testInitializeFirstOccurence [
	| library |
	library := DocLibrary new.
	library addNewBook.
	library books first	addNewChapter;
	addNewChapter;
	addNewChapter.
	library books first chapters first source: 'this test is a test'.
	searchObject search: 'test' in: library.
	searchObject initializeFirstOccurence.
	self assert: searchObject firstOccurence equals: #(1 1 1)asOrderedCollection
	
]

{ #category : #tests }
SearchBookTest >> testInitializeLastOccurence [
	| library |
	library := DocLibrary new.
	library addNewBook.
	library books first	addNewChapter;
	addNewChapter;
	addNewChapter.
	library books first chapters first source: 'this test is a test'.
	searchObject search: 'test' in: library.
	searchObject initializeLastOccurence.
	self assert: searchObject lastOccurence equals: #(1 1 2)asOrderedCollection
	
]

{ #category : #tests }
SearchBookTest >> testNbOccurence [
	searchObject indexOfSubstring: 'test' in: 'test other test word'.
	self assert: searchObject nbOccurence equals: 2
	
]

{ #category : #tests }
SearchBookTest >> testNextBook [
	searchObject search: 'test' in: library.
	self assert: searchObject next.
	self assert: searchObject next.
	self assert: searchObject next.
	self assert: searchObject actualIndex equals: 1.
	self assert: searchObject actualChapter equals: 2.
	self assert: searchObject actualBook equals: 2
	
]

{ #category : #tests }
SearchBookTest >> testNextChapter [
	searchObject search: 'test' in: library.
	self assert: searchObject next.
	self assert: searchObject next.
	self assert: searchObject actualIndex equals: 1.
	self assert: searchObject actualChapter equals: 2.
	self assert: searchObject actualBook equals: 1
	
]

{ #category : #tests }
SearchBookTest >> testNextIndex [
	searchObject search: 'test' in: library.
	self assert: searchObject next.
	self assert: searchObject actualIndex equals: 2.
	self assert: searchObject actualChapter equals: 1.
	self assert: searchObject actualBook equals: 1
	
]
