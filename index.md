---
title       : Enron Data Series 
subtitle    : Get your data into shape
author      : Christina Brady
job         : Data Scientist, World Bank
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---&vcenter
## Workshop Objectives:
  
1. Download Data
2. Explore: Use a R to understand what data is here, what it looks like and how it is organized.
3. Plan: Decide in which format we need the data in order to conduct analysis.
4. Format: Get the data into that format.  

--- &vcenter
## Download the data  
  
  
Download the data [here] (https://www.cs.cmu.edu/~./enron/).

--- &vcenter
## Explore  
  
  
* How many folders are there?
* What do they contain?
* How many subfolders are there?
* What format are the files in?
* What kind of information do they contain? Is it consistent?

--- &vcenter
## Plan  
  
* Who writes to and receives email from whom? (Network analysis) 
* Can we determine what topics are in the emails? (Text Analysis) 
* Can we summarize the emails? (Text Analysis) 
* Can we detect who is involved in fraud from their emails? (Classification)
* Can we detect if a writer is male or female? (Classification)

--- &vcenter
## Format: Network Analysis (1/2)  
For igraph and circlize, you need a dataframe of edges and a data frame of links that look like this:    
###### Edges:

```
##       name              email
## 1 Jane Doe jane.doe@enron.com
## 2 John Doe john.doe@enron.com
```
###### Links:

```
##                        to               from weights
## 1      jane.doe@enron.com john.doe@enron.com       4
## 2 princess.leia@enron.com john.doe@enron.com      10
```

--- &vcenter
## Format: Network Analysis (2/2)  
For network analysis, we may also use an adjacency matrix, which looks like this:  

```
##               jane_doe princess_leia john_doe
## jane_doe             0             1        2
## princess_leia        1             0        2
## john_doe             1             0        1
```

--- &vcenter
## Format: Text Analysis
For topic modeling or to use the text in classification, we need our documents in a document term matrix (tm package).  


```
##         assign deal financial structure
## email_1      1    1         0         0
## email_2      1    0         1         0
## email_3      1    0         1         0
```

--- &vcenter
## Format: Classification  
For regression, trees, random forests, etc., we need a matrix of features.


```
##            name fraudster email_topic ave_email_length
## 1      Jane Doe         1    football               25
## 2 Princess Leia         0  resistence               10
## 3      Han Solo         1        Leia               30
```


--- &vcenter
## Resources:
- Quick igraph [example] (https://www.r-bloggers.com/an-example-of-social-network-analysis-with-r-using-package-igraph/). 
- igraph [vignette] (http://www.kateto.net/wp-content/uploads/2016/01/NetSciX_2016_Workshop.pdf).
- circlize vignette
- tm package
- topic models package
