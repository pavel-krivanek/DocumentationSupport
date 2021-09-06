title: 'Microdown Cheat Sheet'
key: '3z9zm795f0wjg34wm5gruk4ns'
parent: '91bclk1izenja63tom5j39v34'
nextChapter: 'ab92jsbrj7b3ivavuhtygnud0'

# level 1
## level 2
### level 3
#### level 4
##### level 5
###### level 6

This is another chunk of text that could be very large, and we want to put stuff here in order to see how newlines behave.
Moreover this sentence is part of the same paragraph.

**Bold
and a bold again.
**

Here is some code

```
   1000 factorial / 999 factorial
```

Here is a list:
- item 1
- item 2
  - sub item 1 
  - sub item 2
    - even more nested with some content that can be arbitrarily large and here we want to see how indentation can be handled.
this is another string.

ordered list

1. first
2. second

**Bold**, _italic_, `monospace`

In Pharo, Microdown supports hyperlinks to: 
- classes e.g., `Point`
- methodes e.g., `Point class` and `Point>>#setX:setY:` and, finally, 
- packages e.g., `Microdown`

Reference to another chapter:
[Introduction](ref://91bclk2xxrcv7dyhcvj7ay9tk)

Reference to another chapter with inclusion:
[Introduction](include://91bclk2xxrcv7dyhcvj7ay9tk)

!! This is a annotated block (important)
this line belongs to the annotation
and even this.

This line is in a new paragraph.

% an invisible comment

horizontal line:
***

some 

> This is a quote
> with two lines.

Here is a figure and a link: [http://pharo.org](http://pharo.org).

![Pharologo](https://files.pharo.org/media/logo/logo.png)
