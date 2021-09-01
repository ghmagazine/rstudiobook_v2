# 2-3 Rによるスクレイピング入門

## rvest パッケージ

# rvestはtidyverseパッケージと一緒にインストールされる
install.packages("tidyverse")

# rvest パッケージの読み込み
library(rvest)

## Webページタイトルの抽出

# URLは変数にしておく
kabu_url <- "https://kabutan.jp/stock/kabuka?code=0000"

# スクレイピングしたいURLを読み込む
url_res <- read_html(kabu_url)

url_res

# URL の読み込み結果から、title要素を抽出
url_title <- html_element(url_res, css = "head > title")
# または
# url_title <- html_element(url_res, xpath = "/html/head/title")
url_title

# 抽出した要素を文字列に変換
title <- html_text(url_title)
title

title2 <- read_html(kabu_url) %>%
  html_element(css = "head > title") %>%
  html_text()

## パイプ演算子

1:10 %>%
  sum()

sum(1:10)

# パイプ演算子を使わない場合
url_res <- read_html(kabu_url)
url_title <- html_element(url_res, css = "title")
title <- html_text(url_title)

# パイプ演算子を使う場合
title2 <- read_html(kabu_url) %>%
  html_element(css = "title") %>%
  html_text()

## スクレイピング実践

kabuka <- read_html(kabu_url) %>%
  # コピーした XPath を指定
  html_element(xpath = "//*[@id='stock_kabuka_table']/table[2]") %>%
  html_table()
# 先頭 10 行を表示
head(kabuka, 10)

# for文の中で要素を付け加えておくオブジェクトは
# for文の外にあらかじめ空のオブジェクトの用意が必要となる
urls <- NULL
kabukas <- list()

# ページ番号抜きのURLを用意する
base_url <- "https://kabutan.jp/stock/kabuka?code=0000&ashi=day&page="

# 1〜5に対して同じ処理を繰り返す
for (i in 1:5) {
  # ページ番号付きのURLを作成
  pgnum <- as.character(i)
  urls[i] <- paste0(base_url, pgnum)
  
  # それぞれのURLにスクレイピングを実行
  kabukas[[i]] <- read_html(urls[i]) %>%
    html_element(xpath = "//*[@id='stock_kabuka_table']/table[2]") %>%
    html_table() %>%
    # 前日比の列はいったん文字列に変換
    dplyr::mutate(前日比 = as.character(前日比))
  
  # 1ページ取得したら1秒停止
  Sys.sleep(1)
}

# データフレームのリストを縦につなげて1つのデータフレームに
dat <- dplyr::bind_rows(kabukas)

str(dat)

# 2-4 API

## ツイートの収集

# install.packages("rtweet")
# rtweetパッケージをロード
library(rtweet)

# 「技術評論社」を含むツイートを100件検索
rt <- search_tweets(
  "技術評論社", n = 100, include_rts = FALSE
)

# COLUMN: ブラウザの自動操作

install.packages("RSelenium")

library(RSelenium)

# remoteDriverクラスのオブジェクトを作成
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  # 数値のあとに"L"をつけることで「整数」であることを明示
  port = 4445L,
  browserName = "chrome"
)

# ブラウザを立ち上げる
remDr$open()

# e-statのページにアクセス
remDr$navigate("https://e-stat.go.jp/")
# 現在のURLを表示
remDr$getCurrentUrl()

# ブラウザを閉じる
remDr$close()

# Chromeオプションを追加
eCaps <- list(
  chromeOptions =
    list(prefs = list(
      # ポップアップを表示しない
      "profile.default_content_settings.popups" = 0L,
      # ダウンロードプロンプトを表示しない
      "download.prompt_for_download" = FALSE,
      # ダウンロードフォルダを設定
      ## Docker起動時にマウントしたDockerホストのフォルダを記述
      "download.default_directory" = "/home/seluser/Downloads"
    )
    )
)

# eCapsの設定を使ってremoteDriverクラスのオブジェクトを作成
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "chrome",
  extraCapabilities = eCaps
)

# ブラウザ を起動
rem$open()

remDr$navigate("https://e-stat.go.jp/")

# CSS セレクタで要素を指定
# ここでは「地図上に統計データを表示（統計GIS）」
webElem <- remDr$findElement("css selector", "#block-kiwatotetansu > div > div.b-front1_statistical > div:nth-child(5) > div:nth-child(3)")
# 選択した要素をクリック
webElem$clickElement()

Sys.sleep(10)

# 「境界データダウンロード」をクリック
webElem <- remDr$findElement("css selector", "body > div.dialog-off-canvas-main-canvas > div > main > div.row.l-estatRow > section > div.region.region-content > article > div > div > section > ul > li > a:nth-child(5)")
webElem$clickElement()

Sys.sleep(10)

# 「小地域」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > ul > li:nth-child(1) > a")
webElem$clickElement()

Sys.sleep(10)

#「国勢調査」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > ul > li:nth-child(1) > a")
webElem$clickElement()

Sys.sleep(10)

# 「2015年」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > div.stat-search_result-list.js-items > ul:nth-child(1) > li > div.stat-search_result-item2-main.fix.js-row_open_second-parent.js-gisdownload-tabindex > span.stat-plus_icon.js-plus.js-row_open_second.__loaded")
webElem$clickElement()

Sys.sleep(10)

# 「小地域（町丁・字等別集計）」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > div.stat-search_result-list.js-items > ul:nth-child(1) > li > div.stat-search_result-item2-sub.js-child-items.js-row > ul > li:nth-child(1) > div > span.stat-title-has-child > span > a")
webElem$clickElement()

Sys.sleep(10)

# 「世界測地系緯度経度・Shape形式」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > div.stat-search_result-list.js-items > ul:nth-child(1) > li > a")
webElem$clickElement()

Sys.sleep(10)

# 「神奈川県」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > div > div > article:nth-child(14) > div > ul > a > li:nth-child(1)")
webElem$clickElement()

Sys.sleep(10)

# 神奈川全域の「世界測地系緯度経度・Shape形式」をクリック
webElem <- remDr$findElement("css selector", "#main > section > div.js-search-detail > div > div > article:nth-child(1) > div > ul > li:nth-child(3) > a")
webElem$clickElement()

# ブラウザを閉じる
remDr$close()

