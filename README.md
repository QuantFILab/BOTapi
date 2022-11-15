## BOTapi


<b>BOTapi</b> is R package to help R users to batch Thai economics and financial data from Bank of Thailand via API.

## Installation

The easiest way to install the **rmarkdown** package is from within the [RStudio IDE](https://posit.co/download/rstudio-desktop/), but you don't need to explicitly install it or load it, as RStudio automatically does both when needed. A recent version of Pandoc (>= 1.12.3) is also required; RStudio also automatically includes this too so you do not need to download Pandoc if you plan to use rmarkdown from the RStudio IDE.

If you want to use the rmarkdown package outside of RStudio, you can install the package from CRAN as follows:

```r
install.packages("rmarkdown")
```

If you want to use the development version of the rmarkdown package (either with or without RStudio), you can install the package from GitHub via the [**remotes** package](https://remotes.r-lib.org):

```r
remotes::install_github('rstudio/rmarkdown')
```

If not using the RStudio IDE, you'll need to install a recent version of Pandoc (>= 1.12.3); see the [Pandoc installation instructions](https://pandoc.org/installing.html) for help.

## Usage

The easiest way to make a new R Markdown document is from within RStudio. Go to _File > New File > R Markdown_. From the new file wizard, you may:

+ Provide a document title (_optional but recommended_),
+ Provide an author name (_optional but recommended_),
+ Select a default output format- HTML is the recommended format for authoring, and you can switch the output format anytime (_required_), 
+ Click **OK** (_required_).

Once inside your new `.Rmd` file, you should see some boilerplate text that includes code chunks. Use the "Knit" button in the RStudio IDE to render the file and preview the output with a single click or use the keyboard shortcut Cmd/Ctrl + Shift + K. 
