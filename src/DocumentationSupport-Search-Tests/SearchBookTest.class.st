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
	"Put here a common initialization logic for tests"
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
