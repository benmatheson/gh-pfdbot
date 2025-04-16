print("top of the file")


# install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")
install.packages("janitor")
install.packages("stringr")
# install.packages("twitteR")
install.packages('bskyr')
install.packages('jsonlite')

# install.package("ggplot2")
print("after the installation")

# library(ggplot2)
library(readr)
library(dplyr)
library(janitor)
library(stringr)
library(bskyr)
library(jsonlite)

print("afterloading")
# setwd("projects/gh-pfdbot")
# getwd()

print("after the libraryesi")

# stock_data_raw <- read_csv("data/tabula-2022JUN30-Stock-Holdings-by-Country.csv", skip = 0, col_names = F)
# stock_data_raw <- read_csv("data/tabula-2024Dec31-Stock-Holdings-by-Country.csv", skip = 0, col_names = F)
stock_data_raw <- read_csv("data/tabula-2025Mar31-Stock-Holdings-by-Country.csv", skip = 0, col_names = F)

stock_data <- stock_data_raw 

stock_data_names <- c(
  "company_name"	,"shares",	"book_value",	"market_value",	"gain_loss",	"country",	"industry"	,"industry_category") 


names(stock_data) <- stock_data_names


stock_data <- stock_data %>% mutate(shares =str_remove(shares, " "))
stock_data <- stock_data %>% mutate(market_value =str_remove(market_value, " "))

stock_data_dash <- stock_data %>% filter(market_value == "-"  | shares < 1)
stock_data <- stock_data %>% filter(market_value !="-")
# stock_data <- stock_data %>% mutate(market_value = parse_number(market_value))


stock_data <- stock_data %>% mutate(country = str_to_title(country))
stock_data <- stock_data %>% mutate(company_name = str_to_title(company_name))



stock_data_na <- stock_data %>% filter (is.na(market_value) | is.na(company_name) | is.na(shares) | is.na(book_value) | is.na(market_value) | is.na(gain_loss) | is.na(country) | is.na(industry)| is.na(industry_category))
stock_data <- stock_data %>% filter (!company_name  %in% stock_data_na$company_name)






####find a random stock

number_of_stocks <- nrow(stock_data)
random_number <- floor( runif(1)*number_of_stocks)


stock_to_tweet <- stock_data[random_number ,]


flag_data <- read_csv("data/flags.csv")
industry_data <- read_csv("data/industries.csv")

##########################checking flags and industries

# unique_countries <- unique(stock_data$country)
# unique_industries <- unique(stock_data$industry_category)
# 
# 
# unique_countries_flags <- unique(flag_data$country)
# unique_industries_emoji <- unique(industry_data$industry)
# 
# 
# stock_data_no_flag <- stock_data %>% filter (!country %in% unique_countries_flags)
# stock_data_no_industry_emoji <- stock_data %>% filter (industry_category %in% unique_industries_emoji)

##################################################










print("we have read in the csvs. now to select the emoji" )

stock_flag <- (flag_data %>% filter (country == stock_to_tweet$country))$emoji
stock_industry <- (industry_data %>% filter (industry == stock_to_tweet$industry_category))$emoji


print("#####compoose the tweet - format first ")


shares <- format(stock_to_tweet$shares, nsmall=0, big.mark=",",scientific=FALSE)
print( paste0(shares, "- - - shares"))

# market_value <- format(stock_to_tweet$market_value, nsmall =0, big.mark = ",", scientific=FALSE)
market_value <- stock_to_tweet$market_value
market_value <- format(as.numeric(stock_to_tweet$market_value), big.mark = ",", scientific=FALSE)

stock_tweet <- str_glue("Alaskans own {shares} shares of {stock_to_tweet$company_name} worth ${market_value}. It's in the {stock_industry}, {stock_to_tweet$industry_category} industry, based in {stock_flag} {stock_to_tweet$country}.")
print(stock_tweet)
print("getting env vars now")


BSKYPASS <- Sys.getenv("BSKYPASS")

print("now setting up")

set_bluesky_user('pfdbot.bsky.social')
set_bluesky_pass(BSKYPASS)


# options(httr_oauth_cache=F)


print("setup complete")

# bs_post(
#   text = stock_tweet 
# )
bs_post(
  text = paste0(stock_tweet)
)

print("afer posting")

######









