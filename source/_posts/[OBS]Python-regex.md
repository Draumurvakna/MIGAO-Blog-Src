---
aliases:
- Syntax
cover: /gallery/python.png
date:
- 2023-05-09 21:58:07
tags:
- python
- regex
thumbnail: /thumb/python.png
title: regex
toc: true

---

<!--toc:start-->
- [Syntax](#syntax)
- [Usage](#usage)
  - [Use re](#use-re)
  - [Use Pandas](#use-pandas)
- [Example](#example)
  - [Example 1](#example-1)
<!--toc:end-->
---

# Syntax
[regex101](https://regex101.com/)
[regexr](https://regexr.com/)

# Usage
## Use re
```python
re.sub(pattern,repl,str)
re.search(pattern, str)
re.findall(pattern,str)
```

## Use Pandas
```python
df['column_name'].str.contains('pattern')
df['column_name'].str.findall('pattern')
df['column_name'].str.replace('pattern', 'replacement')
```

# Example

## Example 1

Extracting room numbers from a 'Description' column in a DataFrame using regular expressions:

1. Import the `re` module:
```python
import re
````

2.  Define a function to extract the room number from a description:

```python
def extract_room_number(description):
    match = re.search(r'(\d+\.\d+|\d+)(?=\s+of which are bedrooms)', description)
    if match:
        return float(match.group(1))
    else:
        return None
```

3.  Use the `apply()` method to apply the function to the ‘Description’ column and create a new ‘RoomNumber’ column:

```python
df['RoomNumber'] = df['Description'].apply(extract_room_number)
```

This will extract the room number from the ‘Description’ column and store it in the new ‘RoomNumber’ column.
