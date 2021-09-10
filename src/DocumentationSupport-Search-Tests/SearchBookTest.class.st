Class {
	#name : #SearchBookTest,
	#superclass : #TestCase,
	#instVars : [
		'searchObject'
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
