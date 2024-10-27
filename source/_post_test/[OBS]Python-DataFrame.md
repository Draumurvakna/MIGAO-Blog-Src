---
aliases:
- Creating a DataFrame
cover: /gallery/python.png
date:
- 2023-05-09 21:58:07
tags:
- dataframe
- python
- pandas
thumbnail: /thumb/python.png
title: DataFrame
toc: true

---

<!--toc:start-->
- [Creating a DataFrame](#creating-a-dataframe)
- [Location](#location)
- [type transforming](#type-transforming)
- [Groupby and agg](#groupby-and-agg)
- [Example](#example)
  - [Example 1](#example-1)
<!--toc:end-->

# Creating a DataFrame
```python
import pandas as pd
df = pd.read_csv("a.csv")
df = pd.DataFrame({dict_t}) #convert a dict to a dataframe
df = Series_t.to_frame()
```
---
# Location
```python
df.loc[0:4,"Year":"Party"]
df.loc[[1,2,5],["Year","Candidate"]]
df.loc[:,["Year","Candidate"]]
df.loc[:,"year"] # return series
df.loc[1,"year":"Party"] # return series
df.shape[0] # count of row
df[["Year","Candidate"]][0:5]
```
---
# type transforming
```python
df['column_name'] = df['column_name'].astype(int)
df['column_name'] = df['column_name'].astype(float)
df['column_name'] = df['column_name'].astype(str)
```
---
# Groupby and agg
```python
df.groupby('column_name').agg(['sum', 'mean', 'max', 'min'])
df.groupby(['column_name_1', 'column_name_2']).agg({'column_name_3': ['sum', 'mean'], 'column_name_4': ['max', 'min']})
df.groupby(['column_name_1', 'column_name_2']).agg(['sum', 'mean', 'max', 'min'])
```


# Example

## Example 1

Extracting the top 20 categories from a DataFrame using `groupby`:

1. Use the `groupby` and `size` methods to calculate the size of each group:
```python
group_sizes = df.groupby('category').size()
````

2.  Use the `sort_values` method to sort the group sizes in descending order:

```python
sorted_groups = group_sizes.sort_values(ascending=False)
```

3.  Use the `head` method to extract the top 20 categories:

```python
top_20 = sorted_groups.head(20)
```

4.  Use the `isin` method to filter the original DataFrame to only include rows with the top 20 categories:

```python
df_filtered = df[df['category'].isin(top_20.index)]
```

This will extract the top 20 categories from the ‘category’ column of the DataFrame and create a new DataFrame that only includes rows with those categories.

