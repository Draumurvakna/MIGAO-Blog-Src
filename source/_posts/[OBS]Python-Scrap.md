---
aliases:
- Beautiful Soup
cover: /gallery/python.png
date:
- 2023-05-09 21:58:07
tags:
- python
- scrap
- html
- bs4
thumbnail: /thumb/python.png
title: Scrap
toc: true

---

<!--toc:start-->
- [Beautiful Soup](#beautiful-soup)
  - [Generate bs4](#generate-bs4)
  - [find node](#find-node)
  - [siblings](#siblings)
  - [with Regular Expression](#with-regular-expression)
<!--toc:end-->
# Beautiful Soup
## Generate bs4
```python
soup = bs4.BeautifulSoup(text)
```
## find node
```python
soup.find("div", attrs={"id":"..."})
soup.find_all("...")
soup.div
```

## siblings
```python
soup.find("...").next_sibling
soup.find("...").previous_sibling
for elm in soup.div.next_siblings:
    ...
```

## with Regular Expression
```python
soup(class_=re.compile('item-'))
soup(attrs={"class":re.compile("star-rating.*")})[0].get("class")[1]
```
