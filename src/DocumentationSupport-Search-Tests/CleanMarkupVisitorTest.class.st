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
CleanMarkupVisitorTest >> testVisitCodeWithCaption [
	| mic |
	mic := parser parse: '```language=pharo&caption=test for code block
This is a code
```'.
	visitor visit: mic.
	self assert: visitor text equals: '
test for code block
This is a code
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitCodeWithParameters [
	| mic |
	mic := parser parse: '```language=pharo
This is a code
```'.
	visitor visit: mic.
	self assert: visitor text equals: '
This is a code
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitFigure [
	| mic |
	mic := parser parse: '![pharo logo](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Pharo_Logo_v3.0.svg/1200px-Pharo_Logo_v3.0.svg.png)'.
	visitor visit: mic.
	self assert: visitor text equals: '

			pharo logo

'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitFigureWithNoCaption [
	| mic |
	mic := parser parse: '![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Pharo_Logo_v3.0.svg/1200px-Pharo_Logo_v3.0.svg.png)'.
	visitor visit: mic.
	self assert: visitor text equals: '

			

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
CleanMarkupVisitorTest >> testVisitMath [
	| mic |
	mic := parser parse: '&
V_i = C_0 - C_3
&'.
	visitor visit: mic.
	self assert: visitor text equals: '


'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitMathInline [
	| mic |
	mic := parser parse: 'abc$	V_i = C_0 - C_3	$def'.
	visitor visit: mic.
	self assert: visitor text equals: '
abc def
'
]

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitMathWithParameters [
	| mic |
	mic := parser parse: '&key=cite&label=42
V_i = C_0 - C_3
&'.
	visitor visit: mic.
	self assert: visitor text equals: '


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
CleanMarkupVisitorTest >> testVisitParagraphWithFormat [
	| mic |
	mic := parser parse: 'this a _text_ for a **test**'.
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

{ #category : #tests }
CleanMarkupVisitorTest >> testVisitUnorderedListWithNested [
	| mic |
	mic := parser parse: '- 1
- 2
  - 3
  - 4
  - 5
'.
	visitor visit: mic.
	self assert: visitor text equals: '- 1
- 2
- 3
- 4
- 5

'
]
