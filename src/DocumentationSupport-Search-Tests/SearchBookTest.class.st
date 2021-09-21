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
SearchBookTest >> testNbOccurence [
	searchObject search: 'test' in: library.
	self assert: searchObject nbOccurence equals: 4
	
]

{ #category : #tests }
SearchBookTest >> testNext [
	searchObject search: 'test' in: library.
	self assert: searchObject actualIndex index equals: 6.
	searchObject next.
	self assert: searchObject actualIndex index equals: 16.
	searchObject next.
	self assert: searchObject actualIndex index equals: 1.
	searchObject next.
	self assert: searchObject actualIndex index equals: 1.
	
	
]

{ #category : #tests }
SearchBookTest >> testPrev [
	searchObject search: 'test' in: library.
	searchObject next.
	searchObject next.
	searchObject next.
	self assert: searchObject actualIndex index equals: 1.
	searchObject prev.
	self assert: searchObject actualIndex index equals: 1.
	searchObject prev.
	self assert: searchObject actualIndex index equals: 16.
	searchObject prev.
	self assert: searchObject actualIndex index equals: 6.
	
]

{ #category : #tests }
SearchBookTest >> testSearchIn [
	| dictionary |
	dictionary := searchObject search: 'test' in: library.
	self assert: dictionary searchCache first index equals: 6.	
	self assert: dictionary searchCache second index equals: 16.	
	self assert: dictionary searchCache third index equals: 1.	
	self assert: dictionary searchCache fourth index equals: 1.
	
	self assert: dictionary searchCache first book equals: dictionary searchCache second book.
	self assert: dictionary searchCache second book equals: dictionary searchCache third book.
	self assert: (dictionary searchCache first book = dictionary searchCache fourth book) not.		
]
