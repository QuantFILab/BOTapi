###############################################################################
#Developer: Pasin Marupanthorn, Ph.D, AMIMA
#BOtapi: Package for connecting Bank of Thailand Application Programming Interface
#Version: 0.0.2
#Date: 16/11/2022
#Open R package by QunatFILab
###############################################################################


library(httr)
library(jsonlite)


#' @importFrom jsonlite fromJSON
#' @importFrom httr content GET POST
#' 
#' 
###############################################################################
##########General Function#####################################################
###############################################################################


id.header <- function(id){
  return(c('X-IBM-Client-Id' = id, 'accept' ='application/json'))
}

id.header.ii <- function(id){
  return(c('X-IBM-Client-Id' = id, 'accept' ='application/json', 'content-type' = 'application/json'))
}

check.define <- function(){
  Sys.setlocale("LC_CTYPE", "thai")
  options(encoding="UTF-8")
}

input.inlist.check <- function(x,list.in){
  if(!(x %in% list.in)){message(paste0(x,' need to be in the options: ', paste(list.in,collapse=", ") ))}
}

code.status.warn <- function(resp){
  code <- resp$status_code
  if(code != 200){
    message(past0('Respond Code ', code ,' Unsuccessful Request',))
  }
}

###############################################################################
###############################################################################
##########Financial Product Comparison 1.0.5######################################################
###############################################################################
###############################################################################


#' Financial Product
#'
#' Download list of financial product template that financial institutions are required to submit updated information to BOT one day before effective date
#' @param id Client ID obtained from BoT
#' @param data (optional) Specific data of the product, see detail at Bot API page
#' @param type Type of financial product including six options: \cr 
#' Deposit ('deposit'), Personal Loan ('ploan'), Credit Card('credit'), Debit Card ('debit'), and Home Loan ('hloan'); Default setting as 'deposit'  
#' @return List of productions
#' @examples 
#' 
#' deposit <- get.product(id);
#' 
#' data <- list("FICodeList" = "002", \cr 
#' "AccountTypeList" = "1",\cr 
#'  "BalanceAmount" = "",\cr 
#'   "ProductName" = "", \cr 
#'   "DepositTermRange" = "",\cr 
#'    "DepositTermType" = "", \cr 
#'    "InterestWithoutTax" = "",\cr 
#'    "AccntWithInsrnc" = "",\cr 
#'     "ProductRelate" = ""); 
#' deposit.data <- get.product(id, data);
#' 
#' ploan <- get.product(id, type = 'ploan');
#' 
#' @export
get.product <- function(id,data = NULL, type = 'deposit'){
  check.define()
  input.inlist.check(type, c('deposit','ploan','credit','debit','hloan'))
  switch (tolower(type) ,
    deposit = {url <- 'https://apigw1.bot.or.th/bot/public/deposit-product/'},
    ploan   = {url <- 'https://apigw1.bot.or.th/bot/public/personal-loan-product/'},
    credit  = {url <- 'https://apigw1.bot.or.th/bot/public/credit-card-product/v1/'},
    debit   = {url <- 'https://apigw1.bot.or.th/bot/public/debit-atm-product/v1/'},
    deposit = {url <- 'https://apigw1.bot.or.th/bot/public/deposit-product/'},
    hloan   = {url <- 'https://apigw1.bot.or.th/bot/public/home-loan-product/v1/'}
  )
  res <- httr::POST(url = url, httr::add_headers(.headers=id.header.ii(id)),  encode = 'form', body = data)
  code.status.warn(res)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(res.json)
}





###############################################################################
###############################################################################
##########Statistic 1.0.4######################################################
###############################################################################
###############################################################################

###############################################################################
##########Observations 1.0.2###################################################
###############################################################################


#' Observations
#'
#' Batching Data by given series code and initial date \cr 
#' BoT reference: The BOT API products on Statistics include economic and financial, financial Institutions, financial market and payment systems statistics, all of which are published on the BOT Website. Users can filter observations by series code, downloadable from List of Statistics APIs below. \cr 
#' https://www.bot.or.th/Thai/Statistics/API_DOC/API%20Statistic%20time%20series.xlsx
#' @param id Client ID obtained from BoT
#' @param series_code Code of data series provided by BoT
#' @param start_period Star period: format (YYYY-MM-DD)
#' @param end_period (optional) End period: format (YYYY-MM-DD)
#' @param sort_by (optional) Sort data ('asc' or 'desc')
#' @return List of series of data
#' @examples 
#' 
#' series_code <- 'PF00000000Q00232'
#' start_period <- '2017-10-01'
#' end_period <- '2017-11-30'
#' sort_by <- 'desc'
#' 
#' FSI <- get.observe(id, series_code, start_period);
#' 
#' FSI.end <- get.observe(id, series_code, start_period, end_period, sort_by);
#' 
#' @export
get.observe <- function(id, series_code, start_period, end_period = NULL, sort_by =NULL){
  check.define()
  params = list('series_code' = as.character(series_code), 
                'start_period' = start_period, 
                'end_period' = end_period,
                'sort_by' = tolower(sort_by)
                )
  url <- 'https://apigw1.bot.or.th/bot/public/observations/'
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), query = params, encode = 'form')
  code.status.warn(res)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$series))
}


###############################################################################
##########Search Stat APIs 1.0.0###################################################
###############################################################################

#' Search Stat APIs
#'
#' Search data series information by a keyword \cr 
#' BoT reference: User can look for data in BOT API Statistics by keyword search using series code, series name, or relevant terms. The result will be displayed up to 100 series per search.
#' 
#' @param id Client ID obtained from BoT
#' @param keyword keyword for search series
#' @return List of series information
#' @examples 
#' 
#' income.series <- search.stat(id,'income') 
#' 
#' @export
search.stat <- function(id,keyword){
  check.define()
  params = list('keyword' = as.character(keyword))
  url <- 'https://apigw1.bot.or.th/bot/public/search-series/'
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), query = params, encode = 'form')
  code.status.warn(res)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.data.frame(res.json$result$series_details))
}


###############################################################################
##########Stat Category 1.0.0###################################################
###############################################################################

#' Stat Category
#'
#' Get all data categories \cr 
#' BoT reference: Series List Users can call operation to browse all available categories in the system. The system will display the category, description th and description eng in order for users to apply the desired category to search the Series List.
#' 
#' @param id Client ID obtained from BoT
#' @return List of all data categories
#' @examples 
#' 
#' list.cat <- get.category.list(id)
#' 
#' @export
get.category.list <- function(id){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/categorylist/category_list/'
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form')
  code.status.warn(res)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(res.json$result$category)
}



###############################################################################
##########Stat Category 1.0.0###################################################
###############################################################################

#' Stat Series
#'
#' Get all data series in given category \cr 
#' BoT reference: Users can define the category they want by entering the code of the category, for example EC_XT_077. The system will display a list of all series in the Category so that users can apply the series list to retrieve the required information in APIs (Observations).
#' 
#' @param id Client ID obtained from BoT
#' @param category category for get all series in category
#' @return List of all data series in given category
#' @examples 
#' 
#' list.series <- get.series.list(id,'EC_EI_001_S2');
#' 
#' @export
get.series.list <- function(id, category){
  check.define()
  params <- list('category' = as.character(category))
  url <- 'https://apigw1.bot.or.th/bot/public/categorylist/series_list/'
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  code.status.warn(res)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(res.json$result$series)
}



###############################################################################
###############################################################################
##########Exchange Rates 2.0.1######################################################
###############################################################################
###############################################################################


###############################################################################
##########Weighted-average Interbank Exchange Rate - THB / USD 2.0.0###################################################
###############################################################################

#' Weighted-average Interbank Exchange Rate - THB / USD
#'
#' Get weighted-average international bank exchange rate 
#' BoT reference: Daily Weighted-average Interbank Exchange Rate - THB / USD \cr
#' Data is calculated from Daily Intebank Purchases and Sales of US Dollar (against THB) of the transaction worth more than or equal to 1 million USD. The Exchange Rates are calculated using weighted-average between the trading volume and the exchange rate specified.
#' Release schedule : Every business day at 6.00 p.m. (BKK-GMT+07:00) \cr
#' Source of data : 1. Commercial Banks registered in Thailand 2. Foreign Bank Branches 3. Special-purpose Financial Institutions \cr
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param freq (optional) Frequency of data including four options: \cr
#' daily ('d'), monthly ('m'), quarterly ('q'), and annual ('y') \cr
#' Default as daily
#' @return List of weighted-average international bank exchange rate and their information
#' @examples 
#' 
#' m.get.exg.rate <- get.exg.rate(id,'2017-01-01','2017-12-31', freq = 'm');
#' 
#' @export
get.exg.rate  <- function(id, start_period, end_period, freq = 'd'){
  check.define()
  input.inlist.check(freq, c('d','m','q','y'))
  url.endpoint <- 'https://apigw1.bot.or.th/bot/public/Stat-ReferenceRate/v2/'
  switch(tolower(freq),
         d = {root <- 'DAILY_REF_RATE/'},
         m = {root <-'MONTHLY_REF_RATE/'},
         q = {root <-'QUARTERLY_REF_RATE/'},
         y = {root <-'ANNUAL_REF_RATE/'}
         )
  url <- paste0(url.endpoint,root)
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}


###############################################################################
##########Average Exchange Rate - THB / Foreign Currency 2.0.1#################
###############################################################################


#' Average Exchange Rate - THB / Foreign Currency
#'
#' Get average exchange rate - THB / Foreign Currency \cr 
#' BoT reference: The data collected includes the exchange rates quoted for immediate delivery (i.e., in the spot market) between Thai Baht versus 48 other currencies. \cr
#' Exchange rate data are obtained from daily foreign exchange transaction reports from some commercial banks while some exchange rate data are collected from New York Closing and Financial Times. All rates would be converted to Thai Baht equivalent using cross rates quoted by Bangkok Market Closing. \cr
#' Data is calculated from Daily Intebank Purchases and Sales of US Dollar (against THB) of the transaction worth more than or equal to 1 million USD. The Exchange Rates are calculated using weighted-average between the trading volume and the exchange rate specified.
#' Release schedule : Every business day at 6.00 p.m. (BKK-GMT+07:00) \cr
#' Source of data : 1. Commercial Banks registered in Thailand 2. Foreign Bank Branches 3. Special-purpose Financial Institutions 
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param freq (optional) Frequency of data including four options: \cr
#' daily ('d'), monthly ('m'), quarterly ('q'), and annual ('y') \cr 
#' Default as daily
#' @return List of average exchange rate and their information
#' @examples 
#' 
#' m.avg.exg.rate <- get.avg.exg.rate(id,'2017-01-01','2017-12-31', freq = 'm');
#' 
#' @export
get.avg.exg.rate <- function(id, start_period, end_period, freq = 'd'){
  check.define()
  input.inlist.check(freq, c('d','m','q','y'))
  url.endpoint <- 'https://apigw1.bot.or.th/bot/public/Stat-ExchangeRate/v2/'
  switch(tolower(freq),
         d = {root <- 'DAILY_AVG_EXG_RATE/'},
         m = {root <-'MONTHLY_AVG_EXG_RATEE/'},
         q = {root <-'QUARTERLY_AVG_EXG_RATE/'},
         y = {root <-'ANNUAL_AVG_EXG_RATE/'}
  )
  url <- paste0(url.endpoint,root)
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}



###############################################################################
###############################################################################
##########Interest Rate 2.0.0##################################################
###############################################################################
###############################################################################


###############################################################################
##########External Interest Rates (Percent per annum) 2.0.0#################
###############################################################################

#' External Interest Rates (Percent per annum)
#'
#' Get series of external interest rates\cr 
#' BoT reference: External Interest Rates encompass major interest rates \cr
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param rate_type  (optional) Rate Type EX. Libor 1 W in USD (Avg.offered rates)
#' @return List of external interest rates and their information
#' @examples 
#' 
#' ext.rates <- get.ext.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.ext.rates <- function(id, start_period, end_period, rate_type = NULL){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/Stat-ExternalInterestRate/v2/EXT_INT_RATE/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period,
                 'rate_type' = rate_type)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}



###############################################################################
##########Thai Baht Implied Interest Rates (Percent per annum) 2.0.0####################
###############################################################################


#' External Interest Rates (Percent per annum)
#'
#' Get series of Thai Baht implied interest rates \cr 
#' BoT reference: Thai baht Implied Interest Rates refer to interest rate quoted for Baht borrowing through swap market from which the Bank of Thailand disseminates. The rates are those pertaining to domestic market where all transactions are either interbank or between commercial banks and their clients, and interest rates pertaining to foreign markets, which reflect transactions between commercial banks and Non-resident clients. \cr
#'  Frequency : Daily \cr
#'  Lag time : 1 \cr
#'  business; day \cr 
#'  Release schedule : Every business day at 11.00 a.m. \cr
#'  Source of data : Bank of Thailand 
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param rate_type (optional) Rate Type EX. Libor 1 W in USD (Avg.offered rates)
#' @return List of Thai Baht implied interest rates and their information
#' @examples 
#' 
#' tbimplied.rates <- get.tbimplied.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.tbimplied.rates <- function(id, start_period, end_period, rate_type = NULL){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/Stat-ThaiBahtImpliedInterestRate/v2/THB_IMPL_INT_RATE/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period,
                 'rate_type' = rate_type)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}



###############################################################################
##########Spot Rate USD/THB 2.0.0##############################################
###############################################################################


#' Spot Rate USD/THB
#'
#' Get series of spot rate in USD/THB \cr 
#' BoT reference: Spot Rate : USD/THB refers to the exchange rate quoted on the spot market. All trading transactions are verified and settled within two consecutive business day following the trading date. \cr
#' Release schedule : End of every business day at 6.00 p.m.
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @return List of spot rate in USD/THB and their information
#' @examples 
#' 
#' spot.rates <- get.spot.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.spot.rates <- function(id, start_period, end_period){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/Stat-SpotRate/v2/SPOTRATE/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}


###############################################################################
##########Swap point - Onshore (in Satangs) 2.0.0##############################################
###############################################################################


#' Swap point - Onshore (in Satangs)
#'
#' Get series of swap point - onshore in Satangs (Smallest Thai currency unit) \cr 
#' BoT reference: Swap Point Onshore (in Satangs) refers to the difference between the spot and forward exchange rates available at the period of 1, 3 and 6 months. \cr
#' Release schedule : End of every business day at 6.00 p.m. \cr
#' Source of data: Bank of Thailand and Reuters 
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param term_type Term type
#' @return List of series of swap point - onshore and their information
#' @examples 
#' 
#' swap.rates  <- get.swap.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.swap.rates <- function(id, start_period, end_period, term_type = NULL){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/Stat-SwapPoint/v2/SWAPPOINT/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}


###############################################################################
##########Interbank Transaction Rates (Percent per annum) 2.0.0##############################################
###############################################################################


#' Interbank Transaction Rates
#'
#' Get series of International bank transaction rates \cr 
#' BoT reference: Swap Point Onshore (in Satangs) refers to the difference between the spot and forward exchange rates available at the period of 1, 3 and 6 months. \cr
#' Release schedule : Interbank transactions rates are classified by lending period (tenor) such as Overnight (O/N) , Tom/Next , Overnight Forward Start , At Call and Fixed Term. \cr
#' Lag time : 1 business day \cr
#' Release schedule : every business day at 10.00 a.m. \cr
#' Source of data: All commercial banks, Export-Import Bank of Thailand , The Government Savings Bank , Bank for Agricultue and Agricultural Cooperatives , Small and Medium Enterprise Development Bank of Thailand , The Government Housing Bank and Islamic Bank of Thailand, and All finance companies 
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param term_type Term type
#' @return List of series of swap point - onshore and their information
#' @examples 
#' 
#' inter.tran.rates  <- get.inter.tran.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.inter.tran.rates <- function(id, start_period, end_period, term_type = NULL){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/Stat-InterbankTransactionRate/v2/INTRBNK_TXN_RATE/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}


###############################################################################
##########Policy Rate (Percent per annum) 2.0.0##############################################
###############################################################################

#' Policy Rate (Percent per annum)
#'
#' Get current policy rate \cr 
#' BoT reference: Policy Interest Rate is the rate that The Monetary Policy Committee announced in conducting monetary policy under the inflation-targeting framework. The 14-day RP rate was used as the policy interest rate up until 16 January 2007, after which the policy interest rate was switched to the 1- day RP rate. Since 12 February 2008, with the closure of the BOT- run RP market, this was switched to the 1-day bilateral RP rate. \cr
#' Release schedule : Interbank transactions rates are classified by lending period (tenor) such as Overnight (O/N) , Tom/Next , Overnight Forward Start , At Call and Fixed Term. \cr
#' Frequency : Following to the schedule of The Monetary Policy Committee Meeting  \cr
#' Release schedule :  2.05 p.m. of the meeting date \cr
#' Source of data: Bank of Thailand 
#' 
#' @param id Client ID obtained from BoT
#' @return Current policy rate
#' @examples 
#' 
#' inter.tran.rates  <- get.inter.tran.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.policy.rate <- function(id){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/PolicyRate/v2/policy_rate/'
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form')
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.numeric(as.list(res.json$result$data)))
}


###############################################################################
##########Bangkok Interbank Offered Rate (BIBOR) (Percent per annum) 2.0.0##############################################
###############################################################################


#' Bangkok Interbank Offered Rate (BIBOR) (Percent per annum)
#'
#' Get series of Bangkok international bank offered rate  \cr 
#' BoT reference: Interbank transactions rates are classified by lending period (tenor) such as Overnight (O/N) , Tom/Next , Overnight Forward Start , At Call and Fixed Term. \cr
#' Release schedule : every business day at 10.00 a.m.\cr
#' Lag time : 1 business day \cr
#' Source of data: All commercial banks, Export-Import Bank of Thailand , The Government Savings Bank , Bank for Agricultue and Agricultural Cooperatives , Small and Medium Enterprise Development Bank of Thailand , The Government Housing Bank and Islamic Bank of Thailand, and All finance companies 
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param term_type Term type
#' @return List of series of swap point - onshore and their information
#' @examples 
#' 
#' bibor.rates  <- get.bibor.rates(id,'2017-01-01','2017-12-31');
#' 
#' @export
get.bibor.rates <- function(id, start_period, end_period, bank = NULL){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/BIBOR/v2/bibor_rate/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}





###########################################################################################################
##########Deposit Interest Rates for Individuals of Commercial Banks (Percent per annum) 2.0.0#############
###########################################################################################################

#' Deposit Interest Rates for Individuals of Commercial Banks (Percent per annum)
#'
#' Get series of deposit interest rates for individuals of commercial banks  \cr 
#' BoT reference: Refers to the announced deposit interest rate for individual of commercial banks, classified by deposit type such as saving and fixed term deposit. \cr
#' Release schedule : Every business day at 2.00 p.m.\cr
#' Frequency : Daily \cr
#' Source of data: Commercial Banks registered in Thailand and Foreign Bank Branches
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param type Type of obtained data: raw data ('raw') and average data ('avg); Default as 'raw' 
#' @return List of series of deposit interest rates for individuals of commercial banks and their information
#' @examples 
#' 
#' deposit.rates  <- get.deposit.rates(id,'2017-01-01','2017-12-31');
#' deposit.rates.avg  <- get.deposit.rates(id,'2017-01-01','2017-12-31','avg');
#' @export
get.deposit.rates <- function(id, start_period, end_period, type = 'raw'){
  check.define()
  input.inlist.check(type, c('raw','avg'))
  switch(tolower(type),
         raw = {url <- 'https://apigw1.bot.or.th/bot/public/DepositRate/v2/deposit_rate_/'},
         avg =   {url <- "https://apigw1.bot.or.th/bot/public/DepositRate/v2/avg_deposit_rate/"},
  )
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}


###########################################################################################################
##########Loan Interest Rates of Commercial Banks (Percent per annum) 2.0.0################################
###########################################################################################################

#' Loan Interest Rates of Commercial Banks (Percent per annum)
#'
#' Get series of loan interest rates of commercial banks (percent per annum)  \cr 
#' BoT reference: Refers to the announced loan interest rate of commercial banks, classified by loan type such as MOR (Minimun Overdraft Rate), MLR (Minimun Loan Rate) and MRR (Minimun Retail Rate) etc.\cr
#' Release schedule : Every business day at 2.00 p.m.\cr
#' Frequency : Daily \cr
#' Source of data: Commercial Banks registered in Thailand and Foreign Bank Branches
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @param type Type of obtained data: raw data ('raw') and average data ('avg); Default as 'raw' 
#' @return List of series of loan interest rates of commercial banks and their information
#' @examples 
#' 
#' loan.rates <- get.loan.rates(id,'2017-01-01','2017-12-31');
#' loan.rates.avg <- get.loan.rates(id,'2017-01-01','2017-12-31','avg');
#' @export
get.loan.rates <- function(id, start_period, end_period, type = 'raw'){
  check.define()
  input.inlist.check(type, c('raw','avg'))
  switch(tolower(type),
         raw = {url <- 'https://apigw1.bot.or.th/bot/public/LoanRate/v2/loan_rate/'},
         avg =   {url <- "https://apigw1.bot.or.th/bot/public/LoanRate/v2/avg_loan_rate/"},
  )
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}


###############################################################################
###############################################################################
##########Debt Securities Auction Result (Current) 2.0.0#######################
###############################################################################
###############################################################################


#' Debt Securities Auction Result (Current)
#'
#' Get series of debt securities auction result  \cr 
#' BoT reference: Provide the result of Debt securities auction.\cr
#' Release schedule : when the auction is approved \cr
#' Frequency : Following to the auction schedule \cr
#' Source of data: Bank of Thailand \cr
#' Note: BOT has provided more information, such as Classification of Financial Instrument code (cfi_code) and Auction Status (auction_st), on API responses starting September 29, 2017 onward.
#' 
#' @param id Client ID obtained from BoT
#' @param start_period Start Period Date (YYYY-MM-DD) 
#' @param end_period End Period Date (YYYY-MM-DD)
#' @return List of series of loan interest rates of commercial banks and their information
#' @examples 
#' 
#' debt.sec <- get.debt.sec(id,'2018-01-01','2018-12-31');
#' @export
get.debt.sec <- function(id, start_period, end_period){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/BondAuction/bond_auction_v2/'
  params <- list('start_period' = start_period,
                 'end_period' = end_period)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}



###############################################################################
###############################################################################
##########Others 1.0.0#########################################################
###############################################################################
###############################################################################

#' 	Financial Institutions' Holidays
#'
#' Get series of financial institutions' holidays in given year 
#' 
#' @param id Client ID obtained from BoT
#' @param year Year (Ex. 2021) 
#' @examples 
#' 
#' holiday <- get.holiday(id,'2021');
#' @export
get.holiday <- function(id, year){
  check.define()
  url <- 'https://apigw1.bot.or.th/bot/public/financial-institutions-holidays/'
  params <- list('year' = year)
  res <- httr::GET(url = url, httr::add_headers(.headers=id.header(id)), encode = 'form', query = params)
  res.json <- fromJSON(content(res, as = 'text', encoding = "utf-8"))
  return(as.list(res.json$result$data))
}

