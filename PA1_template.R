# Activity monitoring data analysis
activity_analysis <- function(){
    library(ggplot2)
    # load the data
    activity <- read.csv("activity.csv")
    # split na values and non na values 
    na_steps <- activity[is.na(activity$steps),]
    steps <- activity[!is.na(activity$steps), ]
    # get total steps by day
    total_steps <- aggregate(steps ~ date, data = steps, sum)
    # plot histogram of the data

    hist(total_steps$steps, main = "Total steps by day", xlab = "Steps", breaks = 10)

    # calculate and report the mean and the median of the steps
    print(mean(total_steps$steps))
    print(median(total_steps$steps))
    # calculate the mean of steps taken by interval
    activity_mean <- aggregate(steps ~ date, data = steps, mean)
    # plot data in timeline format

    qplot(activity_mean$interval, activity_mean$steps, geom= "line", xlab = "Activity Interval", 
         ylab = "Steps", main = "Average Daily Activity")

    # calculate and report the maximum steps interval
    max_interval <- activity_mean[max(activity_mean$steps), ]
    print(max_interval$interval)
    # calculate and report the total number of missing values
    na_values <- dim(na_steps)[1]
    # replace the na values in the data by the mean value
    # merge the original dataset and the mean by interval dataset calculated before to match
    # each interval value with the corresponding mean of that interval
    interval_mean <- aggregate(steps ~ interval, data= steps, mean)
    complete <- merge(activity, interval_mean, by.x = "interval", by.y = "interval", all = TRUE)
    # find which positions are filled with NA values in the steps.x column and replace that value
    # with the mean of the interval which is in the new steps.y column
    complete$steps.x[which(is.na(complete$steps.x))] <- complete$steps.y[which(is.na(complete$steps.x))]
    # plot an histogram using the new dataset
    total_steps.x<- aggregate(steps.x ~ date, data = complete, sum)
    hist(total_steps.x$steps, main = "Total steps by day", xlab = "Steps", breaks = 10)
    # calculate and report the mean and the median of the steps
    print(mean(total_steps.x$steps.x))
    print(median(total_steps.x$steps.x))
    # Create a new column in the activity dataset to store information about a day
    # being a weekday or a weekend day
    complete <- transform(complete, date = as.Date(complete$date, format="%Y-%m-%d"))
    days <- weekdays(complete$date)
    for (i in 1:length(days)) {
        days[i] <- week(days[i])
    }
    complete$week <- days
    # calculate the average activity by interval and also by weekday
    data <- aggregate(steps.x ~ interval + week, data = complete, mean)
    # plot the data
    qplot(interval, steps.x, data = data, geom = "line", facets = week~., 
          ylab = "steps", main = "Comparison between weekday and weekend activity")
    
}
# auxiliar function to check if a given day is a Weekend day or a Weekday
week <- function(date){
    if(date== "sábado" | date== "domingo"){ result <- "Weekend"}
    else { result <- "Weekday"}
    result
}