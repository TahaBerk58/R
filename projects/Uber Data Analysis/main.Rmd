---
title: "R Notebook"
output: html_notebook
---
```{r}
library(ggplot2)
library(ggthemes)
library(lubridate)
library(dplyr)
library(tidyr)
library(tidyverse) # metapackage of all tidyverse packages
library(DT)
library(scales)
```

---

# Preparing the Data

### Explanation of R Code: Defining Colors

This code block stores specific color codes in a vector. These colors are often used in plots or visualizations.

- `colors = c(...)`: This line defines a vector named `colors`. The `c()` function combines multiple elements into a single vector.
- Each element is a color code in hexadecimal format (e.g., `#CC1011` is a red color).

The output of the code will display the contents of the `colors` vector.
```{r}
colors = c("#CC1011", "#665555", "#05a399", "#cfcaca", "#f5e840", "#0683c9", "#e075b0")
colors
```
### Explanation of R Code: Reading and Combining Uber Data

This code block reads Uber ride data for each month separately and then combines the data into a single dataset.

- **Reading Data:**
  - The `read.csv()` function is used to load CSV files for each month (April to September 2014) into R. Each file contains raw data related to Uber rides for the respective month.
  - The data is stored in variables named `apr`, `may`, `june`, `july`, `aug`, and `sept`, corresponding to the months from April to September.

- **Combining Data:**
  - The `rbind()` function is used to combine these monthly datasets row-wise, creating one large dataset named `data` that contains all the Uber rides from April to September 2014.
  
- **Displaying Data Dimensions:**
  - `dim(data)` returns the dimensions (number of rows and columns) of the combined dataset, which is printed using `cat()` to provide information about the size of the dataset.
```{r}
# Read the data for each month separately 
apr <- read.csv("/Users/tahaberkterekli/Documents/GitHub/R/projects/Uber Data Analysis/Uber-dataset/uber-raw-data-apr14.csv")
may <- read.csv("/Users/tahaberkterekli/Documents/GitHub/R/projects/Uber Data Analysis/Uber-dataset/uber-raw-data-may14.csv")
june <- read.csv("/Users/tahaberkterekli/Documents/GitHub/R/projects/Uber Data Analysis/Uber-dataset/uber-raw-data-jun14.csv")
july <- read.csv("/Users/tahaberkterekli/Documents/GitHub/R/projects/Uber Data Analysis/Uber-dataset/uber-raw-data-jul14.csv")
aug <- read.csv("/Users/tahaberkterekli/Documents/GitHub/R/projects/Uber Data Analysis/Uber-dataset/uber-raw-data-aug14.csv")
sept <- read.csv("/Users/tahaberkterekli/Documents/GitHub/R/projects/Uber Data Analysis/Uber-dataset/uber-raw-data-sep14.csv")

# Combine the data together 
data <- rbind(apr, may, june, july, aug, sept)
cat("The dimensions of the data are:", dim(data))
```
```{r}
# Print the first 6 rows of the data5
head(data)
```
### Explanation of R Code: Converting and Formatting Date and Time

This code block is responsible for converting the `Date.Time` column from a string to a date-time object and then extracting the time separately.

- **Converting `Date.Time` to POSIXct:**
  - `data$Date.Time <- as.POSIXct(data$Date.Time, format="%m/%d/%Y %H:%M:%S")`: This line converts the `Date.Time` column (currently stored as a string) into a POSIXct date-time object, which makes it easier to work with dates and times in R. The format used (`%m/%d/%Y %H:%M:%S`) corresponds to the structure of the date in the dataset (MM/DD/YYYY HH:MM:SS).

- **Extracting the Time:**
  - `data$Time <- format(as.POSIXct(data$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")`: Here, the `format()` function is used to extract just the time (hours, minutes, and seconds) from the `Date.Time` column and store it in a new column named `Time`. This format is `%H:%M:%S`, which corresponds to hours, minutes, and seconds.

- **Converting `Date.Time` to POSIXct using `lubridate`:**
  - `data$Date.Time <- ymd_hms(data$Date.Time)`: This line uses the `ymd_hms()` function from the `lubridate` package to convert the `Date.Time` column to a standardized POSIXct format (with Year, Month, Day, Hour, Minute, Second).

This process ensures that both the date and time components are properly formatted for further analysis.
```{r}
data$Date.Time <- as.POSIXct(data$Date.Time, format="%m/%d/%Y %H:%M:%S")
data$Time <- format(as.POSIXct(data$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")
data$Date.Time <- ymd_hms(data$Date.Time)
```
### Explanation of R Code: Extracting Day, Month, Year, and Day of the Week

This code block creates new columns in the dataset by extracting specific date components (day, month, year, and day of the week) from the `Date.Time` column.

- **Extracting Day:**
  - `data$day <- factor(day(data$Date.Time))`: The `day()` function (from the `lubridate` package) extracts the day of the month from `Date.Time`. The `factor()` function is then used to store the day as a factor, which is useful for categorical data analysis.

- **Extracting Month:**
  - `data$month <- factor(month(data$Date.Time, label=TRUE))`: The `month()` function extracts the month from `Date.Time`. Setting `label=TRUE` converts the numeric month (1-12) into a more readable label (e.g., Jan, Feb). The `factor()` function again ensures that months are treated as categorical variables.

- **Extracting Year:**
  - `data$year <- factor(year(data$Date.Time))`: The `year()` function extracts the year from `Date.Time`, and the `factor()` function converts it into a categorical variable. This could be useful if the data spans multiple years.

- **Extracting Day of the Week:**
  - `data$dayofweek <- factor(wday(data$Date.Time, label=TRUE))`: The `wday()` function extracts the day of the week from `Date.Time` (1 for Sunday, 7 for Saturday). By setting `label=TRUE`, it converts these numbers into weekday labels (e.g., Mon, Tue). The `factor()` function is used to handle it as categorical data.

This step helps in analyzing data based on time-related factors, like understanding trends across different days, months, or weekdays.
```{r}
data$day <- factor(day(data$Date.Time))
data$month <- factor(month(data$Date.Time, label=TRUE))
data$year <- factor(year(data$Date.Time))
data$dayofweek <- factor(wday(data$Date.Time, label=TRUE))
```
### Explanation of R Code: Extracting Hour, Minute, and Second

This code block adds new columns to the dataset by extracting specific time components (seconds, minutes, and hours) from the `Time` column.

- **Extracting Seconds:**
  - `data$second = factor(second(hms(data$Time)))`: 
    - The `hms()` function (from the `lubridate` package) converts the `Time` column, which is in "HH:MM:SS" format, into a time object.
    - The `second()` function extracts the second component (0-59) from this time object.
    - The `factor()` function converts the second values into a categorical variable, which can be useful for categorical analysis.

- **Extracting Minutes:**
  - `data$minute = factor(minute(hms(data$Time)))`: 
    - The `minute()` function extracts the minute component (0-59) from the `Time` column.
    - The `factor()` function converts it into a categorical variable for further analysis.

- **Extracting Hours:**
  - `data$hour = factor(hour(hms(data$Time)))`: 
    - The `hour()` function extracts the hour component (0-23) from the `Time` column.
    - Similarly, `factor()` is used to store hours as a categorical variable.

This step allows for analysis based on time variables, such as identifying trends based on specific hours, minutes, or seconds in the data.
```{r}
# Add Time variables as well 
data$second = factor(second(hms(data$Time)))
data$minute = factor(minute(hms(data$Time)))
data$hour = factor(hour(hms(data$Time)))
```
```{r}
head(data)
```

---

# Data Visualisation

```{r}
hourly_data <- data %>%
                    group_by(hour) %>%
                            dplyr::summarize(Total = n())

datatable(hourly_data)
```
```{r}
# Plot the data by hour
# Plot the data by hour
ggplot(hourly_data, aes(hour, Total)) + 
geom_bar(stat="identity", 
         fill="steelblue", 
         color="red") + 
ggtitle("Trips Every Hour", subtitle = "aggregated today") + 
theme(legend.position = "none", 
      plot.title = element_text(hjust = 0.5), 
      plot.subtitle = element_text(hjust = 0.5)) + 
scale_y_continuous(labels=comma)
```
```{r}
# Aggregate the data by month and hour
month_hour_data <- data %>% group_by(month, hour) %>% dplyr::summarize(Total =n())

ggplot(month_hour_data, aes(hour, Total, fill=month)) +
geom_bar(stat = "identity") +
ggtitle("Trips by Hour and Month") +
scale_y_continuous(labels = comma)
```
```{r}
day_data <- data %>% group_by(day) %>% dplyr::summarize(Trips = n())
day_data
```
```{r}
ggplot(day_data, aes(day, Trips)) +
geom_bar(stat = "identity", fill = "steelblue") +
ggtitle("Trips by day of the month") +
theme(legend.position = "none") + 
scale_y_continuous(labels = comma)
```

