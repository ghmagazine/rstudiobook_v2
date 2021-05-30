library(tidyverse)

# B-1 日付・時刻のデータ型とlubridateパッケージ

Sys.Date()

Sys.time()

library(lubridate)


# B-2 日付・時刻への変換

as.Date("2020-11-01")

as.POSIXct("2020-11-01 13:59:01")

x <- c(
  "20-11-01",       # 年代は下二桁だけ
  "20201101",       # 数字だけ
  "2020年11月1日"   # 日本語
)

ymd(x)

myd("01/2021/30")

# 「年月日時分秒」の形式の文字列
ymd_hms("2020-12-13T20:09:14Z")

# 「日月年時分」の形式の文字列
dmy_hm("13/12/2020 20:09")

ymd_hms("2020-12-13 20:09:14 JST")

ymd_hms("2020-12-13 20:09:14 JST", tz = "Asia/Tokyo")

parse_date_time("2020-11-1 01:10 PM", "YmdHMp")

as_datetime(1604216331)

as_date(18567)

as_date(35981, origin = "1899-12-30")

d <- tibble(
  year  = c(2020, 2021, 2022),
  month = c(  12,    1,    8),
  day   = c(   1,   30,   19)
)

d %>%
  mutate(date = make_date(year = year, month = month, day = day))

csv_text <-
  "dt,value
10/2020/11,1
10/2020/11,2"

# dt列はDate型だと推測してほしいが、普通に読み込むと文字列になってしまう
read_csv(csv_text)

# col_types でフォーマットとともに型を指定
read_csv(csv_text, col_types = cols(dt = col_date("%d/%Y/%m")))


# B-3 日付・時刻データの加工

x <- ymd_hms("2020/07/18 12:34:56")
date(x)

month(x)

x <- ymd(20200101 + 0:9)
x

# 月曜はじまりの週
wday(x, week_start = 1)

# 日曜はじまりの週
wday(x, week_start = 7)

wday(x, week_start = 7, label = TRUE)

wday(x, week_start = 7, label = TRUE, locale = "C")

week(x)

isoweek(x)

epiweek(x)

x <- ymd("2020-03-30")

month(x) <- 4
x

one_month <- months(1)
one_month

x <- ymd(c("2020-03-30", "2020-12-09"))
x + one_month

ymd("2020-01-30") + months(1)

ymd("2020-01-30") %m+% months(1)

ymd("2020-01-30") + days(30)

x <- ymd_hms(c("2020-02-01 20:29:59", "2020-02-01 20:30:00"))
round_date(x, unit = "hour")

# 21時の1秒前、21時ちょうど、21時の1秒後
x <- ymd_h("2020-02-01 21") + seconds(-1:1)
x

# 21時より1秒でも前なら20時に、21時以降なら21時に
floor_date(x, unit = "hour")

# 21時より1秒でも後なら22時に、21時以前なら21時に
ceiling_date(x, unit = "hour")

x <- ymd("2020-02-01") + days(0:5)
x

floor_date(x, unit = "3 days")


# B-4 interval

d <- tibble(
  date = ymd("2021-01-01") + days(0:6),
  value = 1:7
)

d %>%
  filter(
    date >= ymd("2021-01-02"),
    date <= ymd("2021-01-04")
  )

d %>%
  filter(between(date, ymd("2021-01-02"), ymd("2021-01-04")))

i <- interval(
  start = ymd("2021-01-02"),
  end   = ymd("2021-01-04")
)

i

ymd("2021-01-02") %--% ymd("2021-01-04")

d %>%
  filter(date %within% i)

int_start(i)
int_end(i)

int_end(i) <- ymd("2021-01-05")  # 期間の終わりを2021年1月5日に変更

i2 <- ymd_hms("2021-01-02 00:00:00") %--% ymd_hms("2021-01-02 01:02:03")
int_length(i2)


# B-5 日付、時刻データの計算・集計例

x <- make_date(year = 2020, month = 1:6, day = 1)  # 各月1日
w <- wday(x, week_start = 3)                       # 水曜はじまりの週で何番目の曜日か
w

days_to_first_wednesday <- if_else(w == 1, 0, 7 - w + 1)   # (7 - w + 1) %% 7 でも OK
x + days(days_to_first_wednesday)

# 曜日を確認
wday(x + days(days_to_first_wednesday), label = TRUE)

# install.packages("nycflights13") でインストール
library(nycflights13)

head(flights, 3)

flights %>%
  mutate(
    # 日付データを組み立てる
    date = make_date(year, month, day),
    # 各週の初めの日（デフォルトだと日曜日、week_start引数で変更可）のうち、
    # その日付を超えないものの中でもっとも直近のもの
    week = floor_date(date, unit = "week")
  ) %>%
  # 日付と出発地でグループ化
  group_by(week, origin) %>%
  # 便数と平均の遅延時間を計算
  summarise(
    n = n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  )


# B-6 タイムゾーンの扱い

Sys.time()

tz(Sys.time())

tz(ymd_hm("2020-12-12 10:23"))

ymd_hm("2020-12-12 10:23", tz = "Asia/Tokyo")

x <- ymd_hm("2020-12-12 10:23")

force_tz(x, "Asia/Tokyo")

with_tz(x, "Asia/Tokyo")


# B-7 その他の日付・時刻データ処理に関する関数

library(zipangu)

convert_jdate("令和元年10月22日")

x <- ymd("20201101") + days(0:3)
is_jholiday(x)


## sliderパッケージ

library(slider)

set.seed(32)
# 単調増加にランダムなノイズが乗ったデータ
d <- tibble(
  date = ymd("2020-01-01") + days(0:60),
  values = 1:61 + 10 * runif(61)
)

d %>%
  mutate(
    values_slide = slide_period_dbl(
      values,           # 値
      date,             # 値の観測時点
      mean,             # ウィンドウに対して適用する関数
      .period = "day",  # ウィンドウの単位
      .before = 9       # ウィンドウの幅
    )
  )
