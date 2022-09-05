print("top of the file")


install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")
install.packages("janitor")
install.packages("stringr")
install.packages("twitteR")

# install.package("ggplot2")
print("after the installation")

library(ggplot2)
library(readr)
library(dplyr)
library(janitor)
library(stringr)
library(twitteR)

print("afterloading")
# setwd("projects/gh-pfdbot")
# getwd()

print("after the libraryesi")

stock_data_raw <- read_csv("data/tabula-2022JUN30-Stock-Holdings-by-Country.csv", skip = 0, col_names = F)
stock_data_raw <- read_csv("data/tabula-2022JUN30-Stock-Holdings-by-Country cleaned.csv", skip = 0, col_names = F)

stock_data <- stock_data_raw 

stock_data_names <- c(
  "company_name"	,"shares",	"book_value",	"market_value",	"gain_loss",	"country",	"industry"	,"industry_category") 


names(stock_data) <- stock_data_names

stock_data_dash <- stock_data %>% filter(market_value == "-"  | shares < 1)
stock_data <- stock_data %>% filter(market_value !="-")
stock_data <- stock_data %>% mutate(market_value = parse_number(market_value))


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

print("we have read in the csvs. now to select the emoji" )

stock_flag <- (flag_data %>% filter (country == stock_to_tweet$country))$emoji
stock_industry <- (industry_data %>% filter (industry == stock_to_tweet$industry_category))$emoji


print("#####compoose the tweet - format first ")


shares <- format(stock_to_tweet$shares, nsmall=0, big.mark=",",scientific=FALSE)
print( paste0(shares, "- - - shares"))

market_value <- format(stock_to_tweet$market_value, nsmall =0, big.mark = ",", scientific=FALSE)
# market_value <- format(stock_to_tweet$market_value, digits =0, big.mark = ",", scientific=FALSE)

stock_tweet <- str_glue("Alaskans own {shares} shares of {stock_to_tweet$company_name} worth ${market_value}. It's in the {stock_industry} {stock_to_tweet$industry_category}, based in {stock_flag} {stock_to_tweet$country}.")

stock_tweet


# setup_twitter_oauth(consumer_key = api_keys$consumer_key,
#                     consumer_secret = api_keys$consumer_secret,
#                     access_token = api_keys$access_token,
#                     access_secret = api_keys$access_secret)


# https://canovasjm.netlify.app/2021/01/12/github-secrets-from-python-and-r/#read-into-r-script
print("getting env vars now")

CONSUMER_KEY <- Sys.getenv("CONSUMER_KEY")
CONSUMER_SECRET <- Sys.getenv("CONSUMER_SECRET")
ACCESS_TOKEN <- Sys.getenv("ACCESS_TOKEN")
SECRET_KEY <- Sys.getenv("SECRET_KEY")

print("consumer ey ")
print(CONSUMER_KEY)
print("now setting up")

options(httr_oauth_cache=T)

setup_twitter_oauth(consumer_key = CONSUMER_KEY,
                    consumer_secret = CONSUMER_SECRET,
                    access_token = ACCESS_TOKEN,
                    access_secret = SECRET_KEY)


print("setup complete")
tweet(stock_tweet)


######










# 
# 
# current_time <- Sys.time()
# # 
# # basic_plot <- ggplot(stock_data)+
# #   geom_point(aes(x=book_value, y=market_value, size=gainloss), alpha=.2 , show.legend = F)+
# #   theme_minimal()+
# #   ggtitle(current_time)
# 
# 
# ggsave(plot=basic_plot, filename=paste0("data/output/plot.png" ))
# ggsave(plot=basic_plot, filename=paste0("output/plot.png" ))

# ggplot(stock_data)+
#   geom_point(aes(x=book_value, y=market_value, size=gainloss), alpha=.2 , show.legend = F)+
#   theme_minimal()+
#   ggtitle(current_time)+
#   facet_wrap(~industry)+
#   ggsave(paste0("data/output/plot_facet_",current_time ))


