Class {
	#name : #CleanMarkupVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'visitor'
	],
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #initialization }
CleanMarkupVisitorTest >> setUp [
	super setUp.
	parser := MicroDownParser.
	visitor := CleanMarkupVisitor new
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitCode [
	| mic |
	mic := parser parse: '```
This is a code
```'.
	visitor visit: mic.
	self assert: visitor text equals: '
This is a code
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitHeader [
	| mic |
	mic := parser parse: '### This is a header'.
	visitor visit: mic.
	self assert: visitor text equals: '
This is a header
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitHorizontalLine [
	| mic |
	mic := parser parse: ('aaaaa' repeat: 20) ,'
***'.
	visitor visit: mic.
	self assert: visitor text equals: '
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                                                                                    
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitOrderedList [
	| mic |
	mic := parser parse: '1. 1
2. 2
3. 3
'.
	visitor visit: mic.
	self assert: visitor text equals: '1. 1
1. 2
1. 3
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitParagraph [
	| mic |
	mic := parser parse: 'this a text for a test'.
	visitor visit: mic.
	self assert: visitor text equals: '
this a text for a test
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitUnorderedList [
	| mic |
	mic := parser parse: '- 1
- 2
- 3
'.
	visitor visit: mic.
	self assert: visitor text equals: '- 1
- 2
- 3
'
]
