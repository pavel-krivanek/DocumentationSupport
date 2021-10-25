Class {
	#name : #DocSearchBookTest,
	#superclass : #TestCase,
	#instVars : [
		'searchObject',
		'library'
	],
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #running }
DocSearchBookTest >> setUp [
	super setUp.
	searchObject := DocSearchBook new.
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
DocSearchBookTest >> testNbOccurence [
	searchObject search: 'test' in: library.
	self assert: (searchObject nbOccurence at: 1) equals: 2.
	self assert: (searchObject nbOccurence at: 2) equals: 1.
	self assert: (searchObject nbOccurence at: 3) equals: 1
	
]

{ #category : #tests }
DocSearchBookTest >> testNext [
	searchObject search: 'test' in: library.
	self assert: searchObject actualOccurence index equals: 1.
	searchObject next.
	self assert: searchObject actualOccurence index equals: 2.
	searchObject next.
	self assert: searchObject actualOccurence index equals: 1.
	searchObject next.
	self assert: searchObject actualOccurence index equals: 1.
	
	
]

{ #category : #tests }
DocSearchBookTest >> testPrev [
	searchObject search: 'test' in: library.
	searchObject next.
	searchObject next.
	searchObject next.
	self assert: searchObject actualOccurence index equals: 1.
	searchObject prev.
	self assert: searchObject actualOccurence index equals: 1.
	searchObject prev.
	self assert: searchObject actualOccurence index equals: 2.
	searchObject prev.
	self assert: searchObject actualOccurence index equals: 1.
	
]

{ #category : #tests }
DocSearchBookTest >> testSearchIn [
	| dictionary |
	dictionary := searchObject search: 'test' in: library.
	self assert: dictionary searchCache first index equals: 1.	
	self assert: dictionary searchCache second index equals: 2.	
	self assert: dictionary searchCache third index equals: 1.	
	self assert: dictionary searchCache fourth index equals: 1.
	
	self assert: dictionary searchCache first book equals: dictionary searchCache second book.
	self assert: dictionary searchCache second book equals: dictionary searchCache third book.
	self assert: (dictionary searchCache first book = dictionary searchCache fourth book) not.		
]
