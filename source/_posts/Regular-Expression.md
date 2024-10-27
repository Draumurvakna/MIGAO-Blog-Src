---
title: Regular-Expression
date: 2022-04-12 21:31:13
tags: 
- Foundation
categories: 
- Note
cover: /gallery/other.png
thumbnail: /thumb/other.png
---
Studying note for regular expression

## Definition
Regular expression describes a pattern of matching string
Can be used to detect/replace/take out specific substring

## Syntax
| symbol | description | example |
|----|----|----|
| ^ | match the beginning of he line |  |
| [ABC] | match all char in [...] | [aeiou]: g*oo*gl*e* r*u*n*oo*b t*ao*b*ao* |
| [^ABC] | match all except those in [...]  |  |
| [A-Z] | describe an interval | [a-z] matchs all lower case char |
| (...) | set groups |  |
| \1...\n | match the same elements as nth group |  |
| {n} | the front element repeats n times|  |
| {n,} | the front element repeats at least n times |  |
| {n,m} | the front element repeats at least n and at most m times  |  |
| . |match any char except (\n,\r), same with [^\n\r] |  |
| \s\S | match all, \s:match all space char, \S:match all non space char, 'return' not included |  |
| \w | match letter,number,underline, equal to [A-Za-z0-9 ] |  |
| \cx | match the control char indicated by x(A-Z/a-z) | \cM: Control-M or return char |
| \f  | match a page change char |  |
| \n\r | match a return symbol |  |
| \t | match a tab |  |
| \v | match a vertical tab |  |
| $ | match the end of the string, to match $ itself, use \$ | |
| * | match the front subexpression multiple or zero times, use \\\* to match * | |
| + | match the front subexpression multiple or one times, use \\+ |  |
| . | match any single char except \\n  |  |
| [ | mark the beginning of a []expression |  |
| ? | match the front subexpression one or zero times, or indicate a non-greedy qualifier |  |
| \| | logic <font color=#00bbbb>or</font> |  |

## Application in Cpp
In cpp, we use `std::regex` to express regular expression, supporting ECMAScripts as default.

### Match
Use `regex_match()` to match <font color=#00bbbb>xml</font> (or <font color=#00bbbb>html</font>) format:
```cpp
std::regex reg("<.*>.*</.*>");

bool ret = std::regex_match("<xml>value</xml>",reg);
assert(ret);


bool ret = std::regex_match("<html>value</html>",reg);
assert(ret);

bool ret = std::regex_match("<xml>value<xml>",reg);
assert(ret);
```

## Search
Use `std::regex_search`.
As long as there exists targets in the string, it will return.
```cpp
std::regex reg("<(.*)>(.*)</(\\1)>");
std::cmatch m;
auto ret = std::regex_search("123<xml>value</xml>456", m, reg);
if (ret){
    for (auto& elem : m)
        std::cout<<elem<<std::endl;
}

```


