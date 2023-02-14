df$col_1 <- as.POSIXct(df$col_1, format = "%m/%d/%Y")

lag_time_diff <- difftime(df$col_1, lag(df$col_1, default = df$col_1[1]), units = "days")
df$group <- cumsum(ifelse(lag_time_diff>5,1,0))


df
#       col_1 col_2 group
#1 2007-11-13     A     0
#2 2007-11-17     B     0
#3 2007-11-19     C     0
#4 2007-11-25     D     1
#5 2007-11-28     E     1
