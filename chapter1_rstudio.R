# 1-2 RStudioの基本操作

## Rのコマンドの実行

str(iris)

# 1から10にそれぞれ1を足して出力
for (i in 1:10) {
  print(i + 1)
}

## オブジェクトの確認

# iris データを読み込む
d <- iris

x <- list(m = matrix(1:10, nrow = 2), v = 1:100, df = iris)

tashizan <- function (a, b) {
  if ((class(a) == "numeric") == FALSE | (class(b) == "numeric") == FALSE) {
    stop("数値を入力してください") # a, b のどちらかが数値型でなければエラーを返す
  }
  a + b
}

## 補完機能

for (i in 1:10) {
  print(i)
}

## Jobs機能

x <- 1 + 1

jobs_demo_results$x

# 1-4 ファイルの読み込み

## R の標準関数の問題点

# CSVファイルの読み込み
system.time(
  dat <- read.csv("SampleData/csv/Sales.csv")
)

# データの内部を俯瞰
# RStudioのEnvironmentペインでも同様の結果を見られる
str(dat)

# インストールしていない場合、tidyverseパッケージのインストール
# install.packages("tidyverse")
library(tidyverse)

# read_csv()での読み込み
dat2 <- read_csv("SampleData/csv/Sales.csv")

# データの内部を俯瞰
str(dat2)

system.time(dat2 <- read_csv("SampleData/csv/Sales.csv"))

# 方法1
dat2 <- read_csv("SampleData/csv/Sales.csv",
                 col_types = cols(col_character(),
                                  col_character(),
                                  col_datetime()))

# 方法2
dat2 <- read_csv("SampleData/csv/Sales.csv", col_types = 'ccT')

# UTF-8でエンコーディングされたファイル
product <- read_csv("SampleData/csv/Products.csv")

# 先頭6行を出力
head(product)

# CP932でエンコーディングされたファイル
product_cp932 <- read_csv("SampleData/csv/Products_cp932.csv")

# 先頭6行を出力
head(product_cp932)

# ファイルのエンコーディングを調べる
guess_encoding("SampleData/csv/Products.csv")

guess_encoding("SampleData/csv/Products_cp932.csv")

# エンコーディングを指定して読み込み
product_enc <- read_csv("SampleData/csv/Products_cp932.csv",
                        locale = locale(encoding = "CP932"))

# 先頭6行を出力
head(product_enc)

# ファイルの書き出し
# 第1引数にオブジェクト名、第2引数にファイル名
write_csv(iris, "iris_tidy.csv")

# 標準関数での書き出し
write.csv(iris, file = "iris.csv")

## Excel ファイルの読み込み

library(readxl)

dat_xl <- read_excel("SampleData/xlsx/Sales.xlsx", sheet = 1)

## SAS,SPSS,STATAファイルの読み込み

library(haven)

# 1-5 RやRStudioで困ったときは

?plot
help(plot)

vignette("dplyr")
