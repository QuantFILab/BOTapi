## BOTapi

**BOTapi** is R package to help R users to batch Thai economics and financial data from Bank of Thailand via API.

## Installation

BOTapi does not appear on CRAN reposity yet so you need to install by the [**remotes** package](https://remotes.r-lib.org). First, install [**remotes** package](https://remotes.r-lib.org), 

```r
install.packages("remotes")
library(remotes)
```

Then you can install **BOTapi** by the following line,

```r
remotes::install_github('QuantFILab/BOTapi')
```

## Usage

First of all, you need to regist an account on the offical BOT API webpage [here](https://apiportal.bot.or.th/bot/public/). Then you can submit a request to access the APIs which can be accessed for free [here](https://apiportal.bot.or.th/bot/public/products). You need to send requests for all APIs catagories (seven) to use all functions in **BOTapi**. You will obatain the **Client ID** on your account dashboard at App menu. Bank of Thailand allows as to access more than 500 data sereis that will benafit from our research and bussiness analystic.


To be easy to use the functions inside the package, you should set variable of Client ID, such as

```r
id <- 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx'
```

You can see the instruction of using in the function information by inputing to console **? function_name**, such as

```r
? get.observe
```

If the package requires some missing functions, please install dependent packages

```r
library(httr)
library(jsonlite)
```

List of data catagories and series for statistics can be found [here](https://github.com/QuantFILab/BOTapi/blob/main/API%20Statistic%20time%20series.xlsx)

List of Functions are shown below.

| Function      | Detail         |  Link to Official Document |
| :---:         |     :---:      |          :---: |    
| get.product   |  get list of financial product for comparison   | [here](https://apiportal.bot.or.th/bot/public/node/6108)   |
| get.observe   |  get statistics by input data series     |  [here](https://apiportal.bot.or.th/bot/public/node/9820)    |
| search.stat   |  search data series by keyword   |  [here](https://apiportal.bot.or.th/bot/public/node/107)   |
| get.category.list    |  get list of allc ategories and codes    |  [here](https://apiportal.bot.or.th/bot/public/node/1111)   |
| get.series.list      |  get list of all series and codes by given catagory   |  [here](https://apiportal.bot.or.th/bot/public/node/1111)   |
| get.exg.rate     |  get list of weighted-average international bank exchange rate    |  [here](https://apiportal.bot.or.th/bot/public/node/407)   |
| get.avg.exg.rate   |   get list of average exchange rate - THB / Foreign Currency    |  [here](https://apiportal.bot.or.th/bot/public/node/503)   |
| get.ext.rates        |  get list of series of external interest rates    |  [here](https://apiportal.bot.or.th/bot/public/node/465)   |
| get.tbimplied.rates     |  get list of series of Thai Baht implied interest rates   |  [here](https://apiportal.bot.or.th/bot/public/node/468)   |
| get.spot.rates   |  get list of series of spot rate in USD/THB    |  [here](https://apiportal.bot.or.th/bot/public/node/466)   |
| get.swap.rates   |  get list of  series of swap point - onshore in Satangs   |  [here](https://apiportal.bot.or.th/bot/public/node/463)   |
| get.inter.tran.rates   |  get list of  series of International bank transaction rates   |  [here](https://apiportal.bot.or.th/bot/public/node/464)   |
| get.policy.rate    |  get current policy rate   |  [here](https://apiportal.bot.or.th/bot/public/node/462)   |
| get.bibor.rates    |  get list of  series of Bangkok international bank offered rate   |  [here](https://apiportal.bot.or.th/bot/public/node/460)   |
| get.deposit.rates   |  get list of  series of deposit interest rates for individuals of commercial banks   |  [here](https://apiportal.bot.or.th/bot/public/node/461)   |
| get.loan.rates   |  get list of  series of loan interest rates of commercial banks (percent per annum)   |  [here](https://apiportal.bot.or.th/bot/public/node/467)   |
| get.debt.sec    |  get list of  series of debt securities auction result   |  [here](https://apiportal.bot.or.th/bot/public/node/120)   |
| get.holiday  |  get list of  series of financial institutions' holidays in given year   |  [here](https://apiportal.bot.or.th/bot/public/node/104)   |

## Examples


```r
library(BOTapi)

#Setting your ID Client
id <- 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx' 

#Setting start date of batching data
start_period <- "2020-01-01"

#sSetting sereis code of the data set "Land monthly price index : Bangkok and vicinities"
series_code <- "EIRPPIM00080"

#Getting list of Data and its information
land <- get.observe(id,series_code ,start_period)

#Checking data unit
land$unit_eng

#Checking last updating
land$last_update_date

#Accessing data
land$observations

#Accessing individual data (in case of multiple results)
land$observations[[1]]
land$observations[[2]]
```

