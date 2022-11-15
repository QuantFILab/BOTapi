## BOTapi


**BOTapi** is R package to help R users to batch Thai economics and financial data from Bank of Thailand via API.

## Installation

BOTapi is not on CRAN reposity yet so you need to install by the [**remotes** package](https://remotes.r-lib.org). First, install [**remotes** package](https://remotes.r-lib.org), 

```r
install.packages("remotes")
```

Then you can install **BOTapi** by the following line,

```r
remotes::install_github('QuantFILab/BOTapi')
```


## Usage

First of all, you need to regist an account on the offical BOT API webpage [here](https://apiportal.bot.or.th/bot/public/). Then you can submit a request to access the API. BOT provides seven APIs whcih can access for free [here](https://apiportal.bot.or.th/bot/public/products). You need to send a request for every APIs to use all function in **BOTapi**. You obatain the **Client ID** on your account dashboard at API menu.


The functions provided in the package are listed in the following table;

