# Analyzing Sexual Harassment in Higher Education (Part 1) Code

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

# What Was the Gender of the Harasser?

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

# What Was Your Status When the Incident(s) Happened?

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

# What Type of Institution Was It?

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

# Institutional Responses to the Harassment...If any?

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
# Your Field/Discipline

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