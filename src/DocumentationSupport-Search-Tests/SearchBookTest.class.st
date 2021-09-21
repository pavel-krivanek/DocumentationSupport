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
SearchBookTest >> testPrevBook [
	searchObject search: 'test' in: library.
	self assert: searchObject next.
	self assert: searchObject next.
	self assert: searchObject next.
	self assert: searchObject prev.
	self assert: searchObject prev.
	self assert: searchObject prev.
	self assert: searchObject actualIndex equals: 1.
	self assert: searchObject actualChapter equals: 1.
	self assert: searchObject actualBook equals: 1
	
]
