print("top of the file")


install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")
install.packages("janitor")
# install.package("ggplot2")
 print("after the installation")

library(ggplot2)
library(readr)
library(dplyr)
library(janitor)

print("afterloading")
# setwd("projects/gh-pfdbot")
# getwd()

print("after the libraryesi")

stock_data_raw <- read_csv("data/stock_data_sample.csv")
stock_data <- stock_data_raw %>% clean_names()


stock_data <- stock_data %>% mutate(market_value = as.numeric(market_value))



current_time <- Sys.time()

ggplot(stock_data)+
  geom_point(aes(x=book_value, y=market_value, size=gainloss), alpha=.2 , show.legend = F)+
  theme_minimal()+
  ggtitle(current_time)+
  ggsave(paste0("data/output/plot.png" ))

ggplot(stock_data)+
  geom_point(aes(x=book_value, y=market_value, size=gainloss), alpha=.2 , show.legend = F)+
  theme_minimal()+
  ggtitle(current_time)+
  facet_wrap(~industry)+
  ggsave(paste0("data/output/plot_facet_",current_time ))


