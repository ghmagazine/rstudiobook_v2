## 3-2 tidyrによるtidy dataへの変形

scores_messy <- data.frame(
  名前 = c("生徒A", "生徒B"),
  算数 = c(    100,     100),
  国語 = c(     80,     100),
  理科 = c(     60,     100),
  社会 = c(     40,      20)
)

# tidyverse のパッケージ群を読み込み
library(tidyverse)

pivot_longer(scores_messy,
  cols = c(算数, 国語, 理科, 社会),  # 変形する対象の列を指定
  names_to = "教科",                 # 新しくできるキーの列の名前を指定
  values_to = "点数"                 # 新しくできる値の列の名前を指定
)

# pivot_longer()でtidy dataに変形
scores_tidy <- pivot_longer(scores_messy,
  cols = c(算数, 国語, 理科, 社会),
  names_to = "教科",
  values_to = "点数"
)

# pivot_wider()で横長に戻す
pivot_wider(scores_tidy,
  names_from = 教科,
  values_from = 点数
)

## 3-3 dplyrによる基本的なデータ操作

mpg

d <- data.frame(x = 1:3)
d[, "x"]

# as_tibble()でtibbleに変換
d_tibble <- as_tibble(d)
d_tibble[, "x"]

mpg %>%
  # 列の絞り込み
  select(model, displ, year, cyl)

mpg %>%
  # 列の絞り込み
  select(manufacturer, model, displ, year, cyl) %>%
  # 行の絞り込み
  filter(manufacturer == "audi") %>%
  # 新しい列を作成
  mutate(century = ceiling(year / 100))


mpg %>%
  filter(manufacturer == "audi")

mpg %>%
  filter(manufacturer == "audi", cyl >= 6)

mpg %>%
  filter(manufacturer == "audi" & cyl >= 6)

mpg %>%
  filter(manufacturer == "audi" | cyl >= 6)

mpg %>%
  filter(!(manufacturer == "audi" | cyl >= 6))


## コラム：dplyrの関数内でのコード実行 -----------------------------------------

mpg %>%
  filter(manufacturer == "audi")

# エラーになる
manufacturer == "audi"

mpg$manufacturer == "audi"

mpg[mpg$manufacturer == "audi", ]

# 3つの条件を&で結合
mpg[mpg$manufacturer == "audi" &
    mpg$cyl >=  6 &
    mpg$cyl <  10, ]

mpg %>%
  filter(
    manufacturer == "audi",
    cyl >=  6,
    cyl <  10
  )

mpg %>%
  filter(
    .data$manufacturer == "audi",
    .data$cyl >=  6,
    .data$cyl <  10
  )

## -----------------------------------------------------------------------------


mpg %>%
  arrange(cty)

mpg %>%
  arrange(cty, hwy)

mpg %>%
  arrange(-cty)

# エラーになる
mpg %>%
  arrange(-manufacturer)

mpg %>%
  arrange(desc(manufacturer))

mpg %>%
  arrange(desc(cty, hwy))


mpg %>%
  select(model)

mpg %>%
  select(model, trans)

mpg %>%
  select(manufacturer:year)

mpg %>%
  select(!manufacturer)

mpg %>%
  select(MODEL = model, TRANS = trans)

mpg %>%
  rename(MODEL = model, TRANS = trans)

mpg %>%
  select(starts_with("c"))

mpg %>%
  select(where(is.character))

mpg %>%
  select(where(~ is.character(.x) && n_distinct(.x) <= 6))

mpg %>%
  select(cyl:trans, starts_with("c"))

mpg %>%
  select(where(is.character) & !starts_with("m"))

# エラーになる
starts_with("c")

# エラーになる
mpg %>%
  arrange(starts_with("c"))


mpg %>%
  relocate(class, cyl)

mpg %>%
  # class列とcyl列を、model列の前に移動
  relocate(class, cyl, .before = model)


mpg %>%
  # cylそれぞれの値が6以上なら"6以上"、それ以外なら"6未満"、という列cyl_6を追加
  mutate(cyl_6 = if_else(cyl >= 6, "6以上", "6未満"))

mpg %>%
  # cyl列の後ろに追加
  mutate(cyl_6 = if_else(cyl >= 6, "6以上", "6未満"), .after = cyl)

mpg %>%
  mutate(cyl = if_else(cyl >= 6, "6以上", "6未満"))

mpg %>%
  transmute(cyl_6 = if_else(cyl >= 6, "6以上", "6未満"), year)

mpg %>%
  mutate(
    century = ceiling(year / 100),     # ceiling()は値を切り上げる関数
    century_int = as.integer(century)  # ceiling()の結果は数値型なので、整数型に変換
  )

mpg %>%
  summarise(displ_max = max(displ))


## 3-4 dplyrによる応用的なデータ操作

mpg_grouped <- mpg %>%
  group_by(manufacturer, year)

mpg_grouped %>%
  transmute(displ_rank = rank(displ, ties.method = "max"))

mpg_grouped %>%
  filter(n() >= 20)

mpg_grouped %>%
  summarise(displ_max = max(displ), .groups = "drop")


### コラム：複数の値を返す集約関数と`summarise()` ------------------------------

mpg_grouped %>%
  summarise(
    label = c("min", "max"),
    displ_range = range(displ),
    .groups = "drop"
  )

c(1, 2, 3) + c(1, 2, 3)

c(1 + 1,
  2 + 2,
  3 + 3)

# 長さ3のベクトルなので順位は1～3まである
rank(c(1, 10, 100))

# それぞれ長さ1のベクトルなので順位は1しかない
c(rank(1),
  rank(10),
  rank(100))

# デフォルトだと1つ前の値を返す
lag(1:10)

# nを指定するとその数だけ前の値を返す
lag(1:10, n = 3)

# tibble()はtibbleを作成するための関数
uriage <- tibble(
  day   = c(   1,   1,   2,   2,   3,   3,   4,   4),  # 日付
  store = c( "a", "b", "a", "b", "a", "b", "a", "b"),  # 店舗ID
  sales = c( 100, 500, 200, 500, 400, 500, 800, 500)   # 売上額
)

uriage %>%
  # 店舗IDでグループ化
  group_by(store) %>%
  # 各日について前日の売上との差を計算
  mutate(sales_diff = sales - lag(sales)) %>%
  # 見やすさのため、店舗ごとに日付順になるよう並べ替え
  arrange(store, day)

mean(1:10)

uriage %>%
  group_by(store) %>%
  mutate(
    sales_mean = mean(sales),        # 各店舗の平均売上額
    sales_err  = sales - sales_mean  # 各日の売上と平均売上額との差
  )

uriage %>%
  group_by(store) %>%
  mutate(sales_err = sales - mean(sales))

uriage %>%
  mutate(sales_diff = sales - lag(sales)) %>%
  arrange(store, day)


## コラム: selectのセマンティクスとmutateのセマンティクス ----------------------

mpg %>%
  mutate(new_col = cyl)

mpg %>%
  select(new_col = cyl)


mpg %>%
  select(new_col = 5)

mpg %>%
  select(manufacturer:year)

mpg %>%
  select(1:4)

# エラーになる
mpg %>%
  select(manufacturer + 1)

mpg %>%
  select("model", "year")

cyl <- c("manufacturer", "year")

# manufacturer列、year列が選択される
mpg %>%
  select(all_of(cyl))

# エラーになる
mpg %>%
  mutate(cyl2 = sqrt("cyl"))

mpg %>%
  mutate(cyl2 = sqrt(.data[["cyl"]]), .after = cyl)

col <- "cyl"

mpg %>%
  mutate(cyl2 = sqrt(.data[[col]]), .after = cyl)

# runif()の結果を再現性あるものにするため、乱数のシードを固定
set.seed(1)

# runif()で0～100の範囲の乱数を10個ずつ生成
d <- tibble(
  id    = 1:10,
  test1 = runif(10, max = 100),
  test2 = runif(10, max = 100),
  test3 = runif(10, max = 100),
  test4 = runif(10, max = 100)
)

d %>%
  mutate(
    test1 = round(test1),
    test2 = round(test2),
    test3 = round(test3),
    test4 = round(test4)
  )

d_tidy <- d %>%
  # pivot_longer()でもselectのセマンティクス（コラム参照）が使える
  pivot_longer(test1:test4, names_to = "test", values_to = "value")

d_tidy

d_tidy %>%
  mutate(value = round(value))

d_tidy %>%
  group_by(test) %>%
  summarise(value_avg = mean(value), .groups = "drop")

d_tidy %>%
  mutate(value = round(value)) %>%
  pivot_wider(names_from = test, values_from = value)

d %>%
  select(test1:test4)

d %>%
  transmute(across(test1:test4))

d %>%
  transmute(across(c(test1, test2)))

d %>%
  mutate(across(test1:test4, round))

d %>%
  mutate(across(test1:test4, ~ round(.x)))

d %>%
  filter(if_any(test1:test4, ~ .x > 90))

mpg %>%
  group_by(cyl) %>%
  summarise(
    across(where(is.numeric), sd),            # 数値の列の標準偏差
    count = n(),                              # グループごとの行数
    across(where(is.character), n_distinct),  # 文字列の列のユニークな値の数
    .groups = "drop"
  )

mpg %>%
  group_by(cyl) %>%
  summarise(
    count = n(),
    across(where(is.character), n_distinct),
    across(where(is.numeric), sd),
    .groups = "drop"
  )

mpg %>%
  group_by(cyl) %>%
  summarise(
    across(where(is.numeric), mean),
    across(where(is.numeric), sd),
    .groups = "drop"
  )

mpg %>%
  group_by(cyl) %>%
  summarise(
    across(where(is.numeric), mean, .names = "{.col}_mean"),
    across(where(is.numeric) & !ends_with("_mean"), sd, .names = "{.col}_sd"),
    .groups = "drop"
  )

fns <- list(mean = mean, sd = sd, q90 = ~ quantile(.x, 0.9))

mpg %>%
  group_by(cyl) %>%
  summarise(
    across(where(is.numeric), fns),
    .groups = "drop"
  )


# 3-5 dplyrによる2つのデータセットの結合と絞り込み


uriage

tenko <- tibble(
  day    = c(     1,     2,    3,     4),
  rained = c( FALSE, FALSE, TRUE, FALSE)
)

uriage %>%
  inner_join(tenko, by = "day")

tenko2 <- tibble(
  DAY    = c(     1,     2,    3,     4),
  rained = c( FALSE, FALSE, TRUE, FALSE)
)

uriage %>%
  inner_join(tenko2, by = c("day" = "DAY"))

tenko3 <- tibble(
  DAY    = c(    1,     1,    2,     2,    3),
  store  = c(  "a",   "b",  "a",   "b",  "b"),
  rained = c(FALSE, FALSE, TRUE, FALSE, TRUE)
)

uriage %>%
  inner_join(tenko3, by = c("day" = "DAY", "store"))

uriage %>%
  left_join(tenko3, by = c("day" = "DAY", "store"))

res <- uriage %>%
  left_join(tenko3, by = c("day" = "DAY", "store"))

res %>%
  mutate(rained = coalesce(rained, FALSE))

tenko4 <- tibble(
  day    = c(    2,    3,    3),
  store  = c(  "a",  "a",  "b"),
  rained = c( TRUE, TRUE, TRUE)
)

uriage %>%
  # rowwiseを使うと1行づつ処理されるようになる
  rowwise() %>%
  # dayとstoreが両方とも一致する行がtenko4にあるかを調べる
  filter(any(day == tenko4$day & store == tenko4$store)) %>%
  ungroup()

uriage %>%
  semi_join(tenko4, by = c("day", "store"))

uriage %>%
  inner_join(tenko4, by = c("day", "store"))


# 3-6 tidyrのその他の関数

orders <- tibble(
  id    = c(1, 2, 3),
  value = c("ラーメン_大", "半チャーハン_並", "ラーメン_並")
)

orders %>%
  mutate(
    item   = str_split(value, "_", simplify = TRUE)[, 1],
    amount = str_split(value, "_", simplify = TRUE)[, 2]
  )

orders %>%
  separate(value, into = c("item", "amount"), sep = "_")

orders %>%
  extract(value, into = c("item", "amount"), regex = "(.*)_(.*)")

tibble(x = c("beer (3)",  "sushi (8)")) %>%
  extract(x, into = c("item", "num"), regex = "(.*) \\((\\d+)\\)")

tibble(id = 1:3, x = c("1,2", "3,2", "1")) %>%
  separate_rows(x, sep = ",")

orders2 <- tibble(
  day   = c(1, 1, 1, 2),
  item  = c("ラーメン", "ラーメン", "半チャーハン", "ラーメン"),
  size  = c("大", "並", "並", "並"),
  order = c(3, 10, 3, 30)
)

orders2

orders2 %>%
  complete(day, item, size)

orders2 %>%
  complete(day, nesting(item, size))

orders2 %>%
  complete(day, nesting(item, size), fill = list(order = 0))

full_seq(c(1, 2, 4, 5, 10), period = 1)

tibble(
  day   = c(1, 4, 5, 7),
  event = c(1, 1, 2, 1)
) %>%
  complete(
    day = full_seq(day, period = 1),
    fill = list(event = 0)
  )


### コラム：`group_by()`による存在しない組み合わせの表示 -----------------------

d_fct <- tibble(x = c(1, 1, 2, 1), y = c("A", "A", "A", "B"))

d_fct

d_fct %>%
  group_by(x, y) %>%
  summarise(n = n(), .groups = "drop")

d_fct %>%
  group_by(x = factor(x), y = factor(y), .drop = FALSE) %>%
  summarise(n = n(), .groups = "drop")

sales <- tibble(
  year    = c(2000,   NA,   NA,   NA, 2001,   NA,   NA,   NA),
  quarter = c("Q1", "Q2", "Q3", "Q4", "Q1", "Q2", "Q3", "Q4"),
  sales   = c( 100,  200,  300,  400,  500,  100,  200,  300)
)

sales

sales %>%
  fill(year)

d_missing <- tibble(id = c("a", "b", NA), value = c(NA, 1, 2))

d_missing %>%
  replace_na(list(id = "?", value = 0))

d_missing %>%
  mutate(
    id = coalesce(id, "?"),
    value = coalesce(value, 0)
  )

d_missing %>%
  mutate(
    across(where(is.character), coalesce, "?"),
    across(where(is.numeric),   coalesce, 0)
  )
