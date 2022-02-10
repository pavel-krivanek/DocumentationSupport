Class {
	#name : #DocChapterTest,
	#superclass : #TestCase,
	#instVars : [
		'docChapter',
		'text'
	],
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #running }
DocChapterTest >> setUp [
	super setUp.
	docChapter := DocChapter new.
	text := 'first line
second line
third line
fourth line
fifth line
sixth line'
]

{ #category : #tests }
DocChapterTest >> testNumberOfLineOfFrom1To30 [
"first line
second line
third l"
	self assert: (docChapter numberOfLineOf: text from: 1 to: 30) equals: 2
]

{ #category : #tests }
DocChapterTest >> testNumberOfLineOfFrom1ToEnd [
	self assert: (docChapter numberOfLineOf: text from: 1 to: text size) equals: 5
]

{ #category : #tests }
DocChapterTest >> testNumberOfLineOfFrom31ToEnd [
"e
fourth line
fifth line
sixth line"
	self assert: (docChapter numberOfLineOf: text from: 31 to: text size) equals: 3
]
