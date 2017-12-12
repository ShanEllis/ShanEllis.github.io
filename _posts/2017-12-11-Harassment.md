---
title: "Analyzing Sexual Harassment in Higher Education (Part 1)"
layout: post
output:
  html_document: default
  pdf_document: default
comments: yes
---

2017 has taught us a lot. Among the many lessons, it's taught us (or maybe more accurately, reminded most of us) that sexual harassment is rampant. While Hollywood and politicians are most heavily under fire at this moment, to think that sexual harassment doesn't happen in one's own discipline would simply be naive. As an academic, I was happy to hear that The Chronicle of Higher Education was looking into cases of sexual harassment in higher education to hopefully change the field for the better.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">The Chronicle is focusing on sexual harassment in higher education, and we&#39;d like to hear from you. Do you have a story to share? There are a few ways to contact us, and you can do so anonymously: <a href="https://t.co/wsOMkJLmAf">https://t.co/wsOMkJLmAf</a></p>&mdash; The Chronicle of Higher Education (@chronicle) <a href="https://twitter.com/chronicle/status/935901224125247489?ref_src=twsrc%5Etfw">November 29, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

In addition to hearing victim's stories, as a data scientist, I personally wanted data to get an idea of *just* how wide-spread sexual harassment is in the academic world. As such, I am indebted to Dr. Karen Kelsky, for writing the survey used to accumulate the data for this analysis. Here, I have included a first-pass analysis of this [survey response data](https://docs.google.com/forms/d/e/1FAIpQLSeqWdpDxVRc-i8OiiClJPluIpjMlM41aUlU2E0rrQ4br_rQmA/viewform) on "Sexual Harassment in the Academy". The impetus for this survey was discussed by its author, Karen Kelsky, Ph.D. in the form of a [blog post on TheProfessorIsIn.com](https://theprofessorisin.com/2017/12/01/a-crowdsourced-survey-of-sexual-harassment-in-the-academy/) on December 1st, 2017. The data analyzed here includes all responses to the survey entered before 12:40 EST on December 11th, 2017.

```r
# load package
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)
library(reshape)
library(htmlTable)
```

```r
## accessed at 12:40pm EST on 2017-12-11
df <- read.csv("~/ShanEllis.github.io/Sexual_Harassment/Sexual Harassment In the Academy_ A Crowdsource Survey.  The Professor Is In - Form Responses 1.csv")
```

# Responses Over Time
There were 1,567 responses over the course of ~10 days. Let me repeat that: **more than 1,500 responses to a blog post in 10 days**. 

```r
df %>% 
  filter(Timestamp!='') %>% 
  mutate(Date=format(as.POSIXct(Timestamp,format='%m/%d/%Y %H:%M:%S'),format='%m/%d/%Y'))  %>% 
  group_by(Date) %>% 
  count() %>%
  dplyr::rename(number_respondents=n) %>%
  ggplot(aes(x=Date,y=number_respondents,label=number_respondents)) + 
  geom_bar(stat = "identity",position="dodge")+
  theme_bw() +
  scale_x_discrete(labels = wrap_format(10))+
  theme(axis.text = element_text(size = 14) ,axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5,size=12), axis.title=element_text(size=20), plot.title=element_text(size=24)) + 
  ggtitle('Date of Response')
```
![](https://ShanEllis.github.io/Sexual_Harassment/response.png)

# What Was the Gender of the Harasser?
In response to the question "What Was the Gender of the Harasser?", there were 1520 responses with 17 unique responses, all of which are plotted below. Among these responses, **1391 harrassers (91.5% of respondents) were reported to be male** and 83 (5.4%) were reported to be female . 

```r
df %>% 
  filter(What.Was.the.Gender.of.the.Harasser.!='') %>% 
  group_by(What.Was.the.Gender.of.the.Harasser.) %>% 
  count() %>% 
  ggplot(aes(x = What.Was.the.Gender.of.the.Harasser.,y = (n / sum(n))*100))+
  geom_bar(stat = 'identity') + 
  ylab('Percent') + 
  theme_bw() +
  scale_x_discrete(labels = wrap_format(10))+
  theme(axis.text = element_text(size = 14), axis.title.x=element_blank(),axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5,size=9),       axis.title=element_text(size=20), plot.title=element_text(size=18)) + 
  ggtitle('What Was the Gender of the Harasser?')
```
![](https://ShanEllis.github.io/Sexual_Harassment/gender.png)

# What Was Your Status When the Incident(s) Happened?

In response to the question "What Was Your Status When the Incident(s) Happened?", there were 857 unique responses. I cleaned up these responses by combining similar responses with different capitalizationsor abbreviations and found the three most frequent responses were "graduate student","phd stduent", and "undergraduate student."

```r
a <- df %>% 
  filter(What.Was.Your.Status.When.the.Incident.s..Happened.!='') %>% 
  mutate(status=tolower(What.Was.Your.Status.When.the.Incident.s..Happened.)) %>%
  mutate(status = replace(status, status=='grad student', 'graduate student')) %>%
  mutate(status = replace(status, status=='grad student ', 'graduate student')) %>%
  mutate(status = replace(status, status=='grad student.', 'graduate student')) %>%
  mutate(status = replace(status, status=='graduate student ', 'graduate student')) %>%
  mutate(status = replace(status, status=='undergrad', 'undergraduate student')) %>%
  mutate(status = replace(status, status=='undergrad ', 'undergraduate student')) %>%
  mutate(status = replace(status, status=='undergraduate', 'undergraduate student')) %>%
  mutate(status = replace(status, status=='undergraduate ', 'undergraduate student')) %>%
  mutate(status = replace(status, status=='undergrad student', 'undergraduate student')) %>%
  mutate(status = replace(status, status=='phd student ', 'phd student')) %>%
  mutate(status = replace(status, status=='ph.d student ', 'phd student')) %>%
  mutate(status = replace(status, status=='ph.d student', 'phd student')) %>%
  mutate(status = replace(status, status=='ph.d. student', 'phd student')) %>%
  mutate(status = replace(status, status=='assistant professor ', 'assistant professor')) %>%
  mutate(status = replace(status, status=='master\'s student', 'masters student')) %>%
  group_by(status) %>% 
  count() %>% 
  arrange(-n) %>% 
  print(n=15) 
  
# get table output
htmlTable(as.data.frame(a[1:15,]))
```

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>status</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>n</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>graduate student</td>
<td style='text-align: center;'>281</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>phd student</td>
<td style='text-align: center;'>93</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>undergraduate student</td>
<td style='text-align: center;'>87</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>assistant professor</td>
<td style='text-align: center;'>67</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>student</td>
<td style='text-align: center;'>34</td>
</tr>
<tr>
<td style='text-align: left;'>6</td>
<td style='text-align: center;'>phd candidate</td>
<td style='text-align: center;'>15</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>postdoc</td>
<td style='text-align: center;'>14</td>
</tr>
<tr>
<td style='text-align: left;'>8</td>
<td style='text-align: center;'>masters student</td>
<td style='text-align: center;'>13</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>adjunct</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>10</td>
<td style='text-align: center;'>first year graduate student</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'>full professor</td>
<td style='text-align: center;'>6</td>
</tr>
<tr>
<td style='text-align: left;'>12</td>
<td style='text-align: center;'>adjunct instructor</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>13</td>
<td style='text-align: center;'>ma student</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>14</td>
<td style='text-align: center;'>professor</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>15</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>student </td>
<td style='border-bottom: 2px solid grey; text-align: center;'>5</td>
</tr>
</tbody>
</table>

Since this does not include everyone, I have attempted to categorize these these responses at a higher level. Here I have combined responses to consider only four categories: students, professors, instructors, and other.

```r
status_df <- df %>% 
  filter(What.Was.Your.Status.When.the.Incident.s..Happened.!='') %>% 
  mutate(status=tolower(What.Was.Your.Status.When.the.Incident.s..Happened.))
  
# students
# note junior faculty problematic with this search
x <- c("student", "undergrad", "freshman", "sophomore", "junior", "senior", "1st year")
students <- grepl(paste(x, collapse = "|"), status_df$status) %>% table

# postdoc
x <- c("postdoc", "post-doc")
postdocs <- grepl(paste(x, collapse = "|"), status_df$status) %>% table

#faculty
x <- c("professor", "instructor", "adjunct", "prof", "faculty", "tenured")
faculty <- grepl(paste(x, collapse = "|"), status_df$status) %>% table

# other (anyone not counted in the other three categories)
other = nrow(status_df) - students["TRUE"] - postdocs["TRUE"] - faculty["TRUE"]
status_highlevel <- melt(as.df.frame(cbind(students=students["TRUE"],postdocs=postdocs["TRUE"],faculty=faculty["TRUE"],other=other)))

ggplot(status_highlevel, aes(variable,y = (value / sum(value))*100)) +
  geom_bar(stat="identity")+ 
  ylab('Percent') +
  xlab('') +
  theme_bw() +
  scale_x_discrete(labels = wrap_format(10))+
  theme(axis.text = element_text(size = 14) ,axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5,size=16), axis.title=element_text(size=20), plot.title=element_text(size=24)) + 
  ggtitle('Your Status when the Incident(s) Happened')
```
![](https://ShanEllis.github.io/Sexual_Harassment/status.png)

Here we see that survey participants were most frequently students when the incident(s) happened. (Note: postdocs do not exist in every field. Their small number likely reflects this fact in both this graph and the graph below.)

# What Was the Status of the Perpetrator(s)...Particularly relative to you?

```r
perp <- df %>% 
  filter(What.Was.the.Status.of.the.Perpetrator.s...Particularly..relative.to.you..!='') %>% 
  mutate(perpetrator=tolower(What.Was.the.Status.of.the.Perpetrator.s...Particularly..relative.to.you..)) %>% 
  group_by(perpetrator) %>% 
  count() %>% 
  arrange(-n) %>% 
  print(n=15)
  
# get table output
htmlTable(as.data.frame(perp[1:15,]))
```
<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>perpetrator</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>n</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>professor</td>
<td style='text-align: center;'>56</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>full professor</td>
<td style='text-align: center;'>40</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>tenured professor</td>
<td style='text-align: center;'>30</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>professor </td>
<td style='text-align: center;'>20</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>graduate student</td>
<td style='text-align: center;'>17</td>
</tr>
<tr>
<td style='text-align: left;'>6</td>
<td style='text-align: center;'>associate professor</td>
<td style='text-align: center;'>16</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>phd student</td>
<td style='text-align: center;'>11</td>
</tr>
<tr>
<td style='text-align: left;'>8</td>
<td style='text-align: center;'>assistant professor</td>
<td style='text-align: center;'>10</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>tenured faculty</td>
<td style='text-align: center;'>10</td>
</tr>
<tr>
<td style='text-align: left;'>10</td>
<td style='text-align: center;'>undergraduate student</td>
<td style='text-align: center;'>10</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'>department chair</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>12</td>
<td style='text-align: center;'>senior faculty</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>13</td>
<td style='text-align: center;'>student</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>14</td>
<td style='text-align: center;'>tenured faculty </td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>15</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>assistant professor </td>
<td style='border-bottom: 2px solid grey; text-align: center;'>6</td>
</tr>
</tbody>
</table>

Summarizing these data into the same four categories, it becomes quite clear that the harasser is most frequently an individual in a position of power.

```r
perp_df <- df %>% 
  filter(What.Was.the.Status.of.the.Perpetrator.s...Particularly..relative.to.you..!='') %>% 
  mutate(status=tolower(What.Was.the.Status.of.the.Perpetrator.s...Particularly..relative.to.you..))
  
# students
# note junior faculty problematic with this search
x <- c("student", "undergrad", "freshman", "sophomore", "junior", "senior", "1st year")
students <- grepl(paste(x, collapse = "|"), perp_df$status) %>% table

# postdoc
x <- c("postdoc", "post-doc")
postdocs <- grepl(paste(x, collapse = "|"), perp_df$status) %>% table

#faculty
x <- c("professor", "instructor", "adjunct", "prof", "faculty", "tenured")
faculty <- grepl(paste(x, collapse = "|"), perp_df$status) %>% table

# other (anyone not counted in the other three categories)
other = nrow(perp_df) - students["TRUE"] - postdocs["TRUE"] - faculty["TRUE"]
perp_highlevel <- melt(as.df.frame(cbind(students=students["TRUE"],postdocs=postdocs["TRUE"],faculty=faculty["TRUE"],other=other)))

ggplot(perp_highlevel, aes(variable,y = (value / sum(value))*100)) +
  geom_bar(stat="identity")+ 
  ylab('Percent') +
  xlab('') +
  theme_bw() +
  scale_x_discrete(labels = wrap_format(10))+
  theme(axis.text = element_text(size = 14) ,axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5,size=16), axis.title=element_text(size=20), plot.title=element_text(size=24)) + 
  ggtitle('Status of the Perpetrator(s)')
```
![](https://ShanEllis.github.io/Sexual_Harassment/perp.png)

# What Type of Institution Was It?
 
When reporting the type of institution, survey participants reported experiencing sexual harassment at all types of institutions. While we could focus on the relative values, I'll note that there are not the same numbers of institutions/agencies in each category. Further, there is likely some selection bias in those who have responded to the survey. For these two reasons, raw numbers likely don't tell the whole story. However, what we can conclude from these data is sexual harassment occurs across the board.
 
```r
  df %>% 
  filter(What.Type.of.Institution.Was.It.!='') %>% 
  group_by(What.Type.of.Institution.Was.It.) %>% 
  count() %>% 
  dplyr::rename(number_respondents=n) %>%
  ggplot(aes(x = What.Type.of.Institution.Was.It.,y = number_respondents)) +
  geom_bar(stat = 'identity') + 
  theme_bw() +
  scale_x_discrete(labels = wrap_format(10))+
  theme(axis.text = element_text(size = 14), axis.title.x=element_blank(),axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5,size=10),       axis.title=element_text(size=20), plot.title=element_text(size=18)) + 
  ggtitle('What Type of Institution Was It?')
```

![](https://ShanEllis.github.io/Sexual_Harassment/institution.png)

# Institutional Responses to the Harassment...If any?

There are 1,004 unique responses to this question, with **at least 202 respondents reporting that nothing was done in response by their institution.** This is unacceptable, and we must do better. In addition, there are at least 93 responses who did not report the harassment. I applaud these indivduals for sharing now. (To those who have shared here for the first time, you don't owe your story to anyone, but I appreciate your strength in sharing now. Thank you.) Three reported their report led to a Title IX invesitation. Three were not sure of the response. The remaining 982 responses are **full** of heart-wrenching stories. Take a look [through the responses](https://docs.google.com/spreadsheets/d/1S9KShDLvU7C-KkgEevYTHXr3F6InTenrBsS9yk-8C5M/htmlview?sle=true#). Individual stories matter.

```r
response <- df %>% 
  filter(Institutional.Responses.to.the.Harassment..If.Any.!='') %>%
  filter(Institutional.Responses.to.the.Harassment..If.Any.!='N/A') %>%
  filter(Institutional.Responses.to.the.Harassment..If.Any.!='n/a') %>%
  group_by(Institutional.Responses.to.the.Harassment..If.Any.) %>% 
  count() %>% 
  arrange(-n) %>% 
  print(n=22)
  
# get table output
htmlTable(as.data.frame(response[1:22,]))
```
<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Institutional.Responses.to.the.Harassment..If.Any.</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>n</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>None</td>
<td style='text-align: center;'>128</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>none</td>
<td style='text-align: center;'>46</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>Not reported</td>
<td style='text-align: center;'>22</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>Did not report</td>
<td style='text-align: center;'>15</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>None.</td>
<td style='text-align: center;'>13</td>
</tr>
<tr>
<td style='text-align: left;'>6</td>
<td style='text-align: center;'>not reported</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>did not report</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>8</td>
<td style='text-align: center;'>I did not report</td>
<td style='text-align: center;'>6</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>None </td>
<td style='text-align: center;'>6</td>
</tr>
<tr>
<td style='text-align: left;'>10</td>
<td style='text-align: center;'>Didn't report</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'>I did not report it</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>12</td>
<td style='text-align: center;'>I didn't report it</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>13</td>
<td style='text-align: center;'>I didn't report it.</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>14</td>
<td style='text-align: center;'>Never reported</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>15</td>
<td style='text-align: center;'>None. </td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>16</td>
<td style='text-align: center;'>I didn't report it. </td>
<td style='text-align: center;'>4</td>
</tr>
<tr>
<td style='text-align: left;'>17</td>
<td style='text-align: center;'>Nothing</td>
<td style='text-align: center;'>4</td>
</tr>
<tr>
<td style='text-align: left;'>18</td>
<td style='text-align: center;'>Title IX investigation</td>
<td style='text-align: center;'>3</td>
</tr>
<tr>
<td style='text-align: left;'>19</td>
<td style='text-align: center;'>unknown</td>
<td style='text-align: center;'>3</td>
</tr>
<tr>
<td style='text-align: left;'>20</td>
<td style='text-align: center;'>Did not report </td>
<td style='text-align: center;'>2</td>
</tr>
<tr>
<td style='text-align: left;'>21</td>
<td style='text-align: center;'>Didn't report </td>
<td style='text-align: center;'>2</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>22</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Didn’t report</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2</td>
</tr>
</tbody>
</table>

# Your Field/Discipline

Survey participants came from 463 unique fields. Participants most frequently reported to be in the fields of 'english', 'history', and 'sociology'. However, as noted above, there is likely selection bias of participants. Rather than focusing in on any one field, the conclusion to draw here is that people are from **many** different fields.

```r
field <- df %>% 
  filter(Your.Field.Discipline!='') %>%
  mutate(field=tolower(Your.Field.Discipline)) %>%
  group_by(field) %>% 
  count() %>% 
  arrange(-n) %>% 
  print(n=15)
  
# get table output
htmlTable(as.data.frame(field[1:15,]))
```
<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>field</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>n</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>english</td>
<td style='text-align: center;'>124</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>history</td>
<td style='text-align: center;'>99</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>sociology</td>
<td style='text-align: center;'>49</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>humanities</td>
<td style='text-align: center;'>32</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>music</td>
<td style='text-align: center;'>31</td>
</tr>
<tr>
<td style='text-align: left;'>6</td>
<td style='text-align: center;'>political science</td>
<td style='text-align: center;'>31</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>psychology</td>
<td style='text-align: center;'>31</td>
</tr>
<tr>
<td style='text-align: left;'>8</td>
<td style='text-align: center;'>biology</td>
<td style='text-align: center;'>29</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>philosophy</td>
<td style='text-align: center;'>27</td>
</tr>
<tr>
<td style='text-align: left;'>10</td>
<td style='text-align: center;'>anthropology</td>
<td style='text-align: center;'>25</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'>creative writing</td>
<td style='text-align: center;'>17</td>
</tr>
<tr>
<td style='text-align: left;'>12</td>
<td style='text-align: center;'>english </td>
<td style='text-align: center;'>17</td>
</tr>
<tr>
<td style='text-align: left;'>13</td>
<td style='text-align: center;'>history </td>
<td style='text-align: center;'>17</td>
</tr>
<tr>
<td style='text-align: left;'>14</td>
<td style='text-align: center;'>literature</td>
<td style='text-align: center;'>17</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>15</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>education</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>16</td>
</tr>
</tbody>
</table>

# Conclusions
* There is a lot of sexual harassment.
* 91.5% of harassers were reported to be male.
* Victims are most frequently students.
* Harassers were most frequently individuals in positions of power.
* Institutions frequently fail to respond to reports of sexual harassment.
* Sexual harassment occurs across many fields and across all types of institutions.


----
### Thank you
* Thank you to everyone who shared their story. You're making a difference. 
* Thank you to [Karen Kelsky, PhD](https://twitter.com/search?q=karen+kelsky) for using her platform to help victims find a safe way to anonymously report sexual harassment. And, thank you for making these data available.

### Limitations
As with all analyses, there are limitations to the interpretation of these data. As mentioned in the post, there is selection bias in who responded to the survey. Participants likely do not perfectly represent academia. While not limited to individuals who follow Dr. Kelsky's blog, her readership likely influences who participated in this survey. Thus, while we cannot interpret these data to conclude in which field sexual harassment is most frequent, we can conclude that sexual harassment is wide-spread across many fields and read the stories of the participants who participated. Additionally, I pulled these data while the survey was still running. Values will likely change over time as a result. Finally, these are self-reported data, which have not been independently verified.

### Follow-up
This is Part 1 of my analysis of these data. I plan to analyze people's stories and free text responses in more detail than I would have been able to do so sufficiently for a first blog post. If someone else beats me to this, awesome. The faster we are able to help victims of sexual harassment and understand how widespread this is in academia, the better.  

  