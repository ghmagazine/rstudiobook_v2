# 準備（p.225） ----------------------------------------------------------------------
library(tidyverse)
#または、library(stringr)


# str_c()（p.225） -------------------------------------------------------------
## サンプルデータの作成
names <- data.frame(family_name = c("Matsumura", "Yutani", "Kinosada", "Maeda"),
                    first_name = c("Yuya", "Hiroaki", "Yasunori", "Kazuhiro"))

## 姓名を結合した文字列ベクトルの作成
names_join <- str_c(names$family_name, names$first_name, sep = " ")

## 引数`collapse`を指定した場合
str_c(names$family_name, names$first_name, sep = " ", collapse = ",")


# str_split()（p.226） -------------------------------------------------------------
str_split(string = names_join, pattern = " ", n = 2)

str_split(string = names_join, pattern = "a", n = 2)

str_split(string = names_join, pattern = "a", n = 3)

str_split(string = names_join, pattern = "a", n = 3, simplify = TRUE)

str_split_fixed(string = names_join, pattern = "a", n = 3)


# str_detect()（p.228） -------------------------------------------------------------
str_detect(string = names_join, pattern = "hiro")

str_detect(string = names_join, pattern = "hiro", negate = TRUE)


# コラム：fixed()/coll()を用いた挙動の調整（p.229） -------------------------------------------------------------
## サンプルデータの作成
nicknames <- c("JIRO", "JURI", "J.R.", "j.r.")

str_detect(string = nicknames, pattern = "J.R.")

str_detect(string = nicknames, pattern = fixed(pattern = "J.R."))
str_detect(string = nicknames, pattern = coll(pattern = "J.R."))

str_detect(string = nicknames, pattern = fixed(pattern = "J.R.", ignore_case = TRUE))
str_detect(string = nicknames, pattern = coll(pattern = "J.R.", ignore_case = TRUE))

str_detect(string = "a\u0308", pattern = fixed(pattern = "\u00e4"))
str_detect(string = "a\u0308", pattern = coll(pattern = "\u00e4"))


# str_count()（p.231） -------------------------------------------------------------
str_count(string = names_join, pattern = "hiro")

str_count(string = names_join, pattern = coll(pattern = "hiro", ignore_case = TRUE))


# str_locate()（p.231） -------------------------------------------------------------
str_locate(string = names_join, pattern = coll(pattern = "y", ignore_case = TRUE))

str_locate_all(string = names_join, pattern = coll(pattern = "y", ignore_case = TRUE))


# str_subset() / str_extract()（p.232） -------------------------------------------------------------
## str_subset()
str_subset(string = names_join, pattern = "hiro")

str_subset(string = names_join, pattern = coll(pattern = "hiro", ignore_case = TRUE))

str_subset(string = names_join,
           pattern = coll(pattern = "hiro", ignore_case = TRUE),
           negate = TRUE)

## str_extract()
str_extract(string = names_join, pattern = coll(pattern = "hiro", ignore_case = TRUE))


# str_sub()（p.234） -------------------------------------------------------------
str_sub(string = names_join, start = 1, end = 3)

str_sub(string = names_join, start = -3, end = -1)


# str_replace()（p.234） -------------------------------------------------------------
str_replace(string = names_join, pattern = "y", replacement = "-")

str_replace(string = names_join,
            pattern = coll(pattern = "y", ignore_case = TRUE),
            replacement = "-")

str_replace_all(string = names_join,
                pattern = coll(pattern = "y", ignore_case = TRUE),
                replacement = "-")

str_replace_all(string = names_join,
                pattern = coll(pattern = "y", ignore_case = TRUE),
                replacement = "")


# str_trim() / str_squish()（p.236） -------------------------------------------------------------
## サンプルデータの作成
blanks <- c(" 北海道", "東京都 ", " 京都府 ", " 福 岡 県 ")

## str_trim()
str_trim(blanks)
str_trim(blanks, side = "left")

## str_squish()
str_squish(blanks)


# str_to_upper() / str_to_lower()（p.238） -------------------------------------------------------------
str_to_upper(names_join)

str_to_lower(names_join)

umlaut <- c("\u00e4", "\u00f6", "\u00fc")
str_to_upper(umlaut)


# 正規表現（p.240） -------------------------------------------------------------
str_locate_all(string = "Simons et al. (2016)", pattern = ".")

str_locate_all(string = "Simons et al. (2016)", pattern = "\\.")

str_locate_all(string = "Simons et al. (2016)", pattern = "\\(")

str_locate_all(string = "Simons et al. (2016)", pattern = "\\w")

str_locate_all(string = "Simons et al. (2016)", pattern = "\\W")

str_locate_all(string = "Simons et al. (2016)", pattern = "\\d")

str_locate_all(string = "Simons et al. (2016)", pattern = "\\D")

str_locate_all(string = "Simons et al. (2016)", pattern = "[:alpha:]")

str_locate_all(string = c("Rユーザ"), pattern = "[:alpha:]")

str_locate_all(string = "Simons et al. (2016)", pattern = "[1-3]")

str_locate_all(string = "Simons et al. (2016)", pattern = "[a-g]")

str_locate_all(string = "Simons et al. (2016)", pattern = "[1-3]|[6-8]")

str_locate_all(string = "Simons et al. (2016)", pattern = "Si|mo|n|s")

str_locate_all(string = "Simons et al. (2016)", pattern = "[Simons]")

str_locate_all(string = "Simons et al. (2016)", pattern = "[^Simons]")

str_detect(string = "Simons et al. (2016)", pattern = "^Si")

str_detect(string = "Simons et al. (2016)", pattern = "^Sa")

str_detect(string = names_join, pattern = "^[Maeda]")

str_detect(string = "Simons et al. (2016)", pattern = "\\(2016\\)$")

str_detect(string = "Simons et al. (2016)", pattern = "\\(2021\\)$")

## regex()
str_locate_all(string = "Simons et al. (2016)", pattern = fixed(pattern = "[Q-S]", ignore_case = TRUE))
str_locate_all(string = "Simons et al. (2016)", pattern = coll(pattern = "[Q-S]", ignore_case = TRUE))

str_locate_all(string = "Simons et al. (2016)[Q-S]", pattern = fixed(pattern = "[Q-S]", ignore_case = TRUE))
str_locate_all(string = "Simons et al. (2016)[Q-S]", pattern = coll(pattern = "[Q-S]", ignore_case = TRUE))

str_locate_all(string = "Simons et al. (2016)", pattern = regex(pattern = "[Q-S]", ignore_case = TRUE))


