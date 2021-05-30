# 準備（p.141） ----------------------------------------------------------------------
install.packages("tidyverse")
library(tidyverse)


# 新しいキャンバスの用意（p.142） -------------------------------------------------------------
g <- ggplot()


# 図4.2（p.143）-----------------------------------------------------
## 左図
ggplot() +
  geom_histogram(data = mpg, mapping = aes(x = displ))

## 右図
ggplot() +
  geom_density(data = mpg, mapping = aes(x = displ))


# 図4.3（p.144） -----------------------------------------------------
ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = cty))


# 図4.4（p.145） -----------------------------------------------------
ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = cty), method = "lm")

## 別の方法
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  geom_smooth(method = "lm")


# 図4.5（p.146） -----------------------------------------------------
mpg1999 <- filter(mpg, year == 1999)
mpg2008 <- filter(mpg, year == 2008)

ggplot(mapping = aes(x = displ, y = cty)) +
  geom_point(data = mpg1999) +
  geom_point(data = mpg2008)


# 図4.6（p.147） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty, group = cyl, colour = cyl)) +
  geom_point()

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty, group = factor(cyl), colour = factor(cyl))) +
  geom_point()


# 図4.7（p.147） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  geom_smooth(mapping = aes(group = factor(cyl), colour = factor(cyl)), method = "lm")

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  geom_smooth(mapping = aes(group = factor(cyl)), method = "lm")


# 図4.8（p.148） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point(mapping = aes(colour = factor(cyl), shape = factor(cyl)))

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  geom_smooth(mapping = aes(colour = factor(year), linetype = factor(year)), method = "lm")


# 図4.9（p.149） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty, colour = factor(cyl))) +
  geom_point(shape = 17, size = 4, alpha = 0.4)

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point(colour = "chocolate", shape = 35, size = 10) +
  geom_smooth(method = "lm", linetype = "dashed", se = FALSE)


# 図4.10（p.150） -----------------------------------------------------
add_x <- c(2.5, 3, 3.5)
add_y <- c(25, 27.5, 30)

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  annotate(geom = "point", x = add_x, y = add_y, colour = "red") +
  annotate(geom = "text", x = c(5, 5), y = c(30, 25), label = c("要チェック！", "赤色のデータを追加"))


# 図4.11（p.151） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  facet_wrap( ~ cyl)

## 中央
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  facet_grid(. ~ cyl)

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  facet_grid(cyl ~ .)



# 図4.12（p.151） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  facet_wrap(year ~ cyl)

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  facet_grid(year ~ cyl)


# 図4.13（p.152） -----------------------------------------------------
mean_cty <- mpg %>% 
  group_by(class) %>% 
  summarise(cty = mean(cty))

ggplot(data = mean_cty, mapping = aes(x = class, y = cty)) +
  geom_bar(stat = "identity")

## 別の方法1
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  geom_bar(stat = "summary", fun = "mean")

## 別の方法2
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "bar", fun = "mean")


# 図4.14（p.154） -----------------------------------------------------
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "pointrange", fun = "mean", fun.max = "max", fun.min = "min")


# 図4.15（p.155） -----------------------------------------------------
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "bar", fun = "mean", fill = "grey") +
  stat_summary(geom = "pointrange", fun.data = "mean_se")


# 図4.16（p.156） -----------------------------------------------------
ggplot(data = mpg, mapping = aes(x = factor(year), y = displ)) +
  stat_summary(fun.y = "mean", geom = "line", group = 1)


# 図4.17（p.157） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "bar", fun = "mean") +
  geom_point(mapping = aes(colour = class), show.legend = FALSE)

## 右図
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  geom_violin(scale = "count") +
  geom_point(mapping = aes(colour = class), show.legend = FALSE)


# 図4.18（p.158） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "bar", fun = "mean") +
  geom_jitter(mapping = aes(colour = class), show.legend = FALSE)

## 右図
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "bar", fun = "mean") +
  geom_jitter(mapping = aes(colour = class), width = 0.2, height = 0, show.legend = FALSE)


# 図4.19（p.159） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = class, y = cty, fill = factor(year)))+
  stat_summary(geom = "bar", fun = "mean")+
  stat_summary(fun.data = "mean_se")

## 中央
ggplot(data = mpg, mapping = aes(x = class, y = cty, fill = factor(year)))+
  geom_bar(stat = "summary", fun = "mean")+
  stat_summary(fun.data = "mean_se")

## 右図
ggplot(data = mpg, mapping = aes(x = class, y = cty, fill = factor(year)))+
  stat_summary(geom = "bar", fun = "mean", position = position_dodge())+
  stat_summary(fun.data = "mean_se", position = position_dodge(width = 0.9))


# 図4.20（p.160） -----------------------------------------------------
## サンプルデータの作成
dodge_sample <- data.frame(category = c("A", "A", "B"),
                           year = as.factor(c(1999, 2008, 1999)),
                           amount = c(8, 12, 10))


## 可視化
ggplot(data = dodge_sample, mapping = aes(x = category, y = amount, fill = year)) +
  geom_col(position = position_dodge())


# 図4.21（p.161） -----------------------------------------------------
## 左図
ggplot(data = dodge_sample, mapping = aes(x = category, y = amount, fill = year)) +
  geom_col(position = position_dodge(preserve = "single"))

## 右図
ggplot(data = dodge_sample, mapping = aes(x = category, y = amount, fill = year)) +
  geom_col(position = position_dodge2(preserve = "single", padding = 0.1))


# 図4.22（p.162） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  geom_vline(xintercept = 4) +
  geom_hline(yintercept = 15) +
  geom_smooth(method = "lm", se = FALSE)

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  xlim(1.5, 4.5) +
  ylim(10, 35) +
  geom_vline(xintercept = 4) +
  geom_hline(yintercept = 15) +
  geom_smooth(method = "lm", se = FALSE)


# 図4.23（p.163） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  geom_vline(xintercept = 4) +
  geom_hline(yintercept = 15) +
  geom_smooth(method = "lm", se = FALSE)

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  coord_cartesian(xlim = c(1.5, 4.5), ylim = c(10, 35)) +
  geom_vline(xintercept = 4) +
  geom_hline(yintercept = 15) +
  geom_smooth(method = "lm", se = FALSE)


# 図4.24（p.164） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = drv, y = cty)) +
  geom_violin() +
  stat_summary(fun.data = "mean_se")

## 右図
ggplot(data = mpg, mapping = aes(x = drv, y = cty)) +
  geom_violin() +
  stat_summary(fun.data = "mean_se") +
  coord_flip()


# 図4.25　グラフの保存（p.165） -----------------------------------------------------
g <- ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  stat_summary(geom = "bar", fun.y = mean)

ggsave(plot = g, filename = "cty_class.png",
       dpi = 300, height = 20, width = 20, units = "cm")


# 図4.26（p.166） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  theme_classic() +
  geom_point()

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  theme_bw() +
  geom_point()


# 図4.27（p.167） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  theme_classic() +
  geom_point()

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  theme_classic(base_size = 30, base_family = "serif") +
  geom_point()


# 図4.28（p.168） -----------------------------------------------------
## サンプルデータの作成
dat_text <- data.frame(ABC = 1:3, D = 2, names = LETTERS[1:3])

## 左図
ggplot(data = dat_text, mapping = aes(x = ABC, y = D, label = names)) +
  theme_classic(base_size = 20, base_family = "serif") +
  geom_text()

# 右図
ggplot(data = dat_text, mapping = aes(x = ABC, y = D, label = names)) +
  theme_classic(base_size = 20, base_family = "serif") +
  geom_text(size = 15, family = "serif")


# 図4.29（p.169） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## 右図
theme_set(theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1)))
ggplot(data = mpg, mapping = aes(x = class, y = cty)) +
  geom_boxplot()


# 図4.30（p.170） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = drv, y = cty, fill = drv)) +
  geom_boxplot()

## 右図
ggplot(data = mpg, mapping = aes(x = drv, y = cty, fill = drv)) +
  geom_boxplot() +
  scale_fill_manual(values = c("4" = "black", "f" = "grey", "r" = "#ffffff"))

## 輪郭と塗りつぶしの色をともに指定する方法1
ggplot(data = mpg, mapping = aes(x = drv, y = cty, colour = drv, fill = drv)) +
  geom_boxplot() +
  scale_colour_manual(values = c("4" = "black", "f" = "grey", "r" = "#ffffff")) +
  scale_fill_manual(values = c("4" = "black", "f" = "grey", "r" = "#ffffff"))

## 輪郭と塗りつぶしの色をともに指定する方法2
ggplot(data = mpg, mapping = aes(x = drv, y = cty, colour = drv, fill = drv)) +
  geom_boxplot() +
  scale_colour_manual(values = c("4" = "black", "f" = "grey", "r" = "#ffffff"),
                      aesthetics = c("colour", "fill"))


# 図4.31（p.171） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = drv, y = cty, fill = drv)) +
  geom_boxplot() +
  scale_fill_grey(start = 0.4, end = 0.9)

## 右図
ggplot(data = mpg, mapping = aes(x = drv, y = cty, fill = drv)) +
  geom_boxplot() +
  scale_fill_grey(start = 1, end = 0)


# 図4.32（p.172） -----------------------------------------------------
install.packages("RColorBrewer") 
library(RColorBrewer)

display.brewer.all()


# 図4.33（p.173） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = drv, y = cty, fill = drv)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Greys")

## 右図
ggplot(data = mpg, mapping = aes(x = drv, y = cty, fill = drv)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Paired")


# 図4.34（p.174） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty, colour = cyl)) +
  geom_point() +
  scale_colour_viridis_c()

## 右図
ggplot(data = mpg, mapping = aes(x = class, y = cty, fill = class)) +
  geom_boxplot(show.legend = FALSE) +
  scale_fill_viridis_d()


# 図4.35（p.174） -----------------------------------------------------
install.packages("ggthemes")
library(ggthemes)
library(scales)
show_col(colorblind_pal()(8))


# 図4.36（p.175） -----------------------------------------------------
ggplot(data = mpg, mapping = aes(x = class, y = cty, fill = class)) +
  geom_boxplot(show.legend = FALSE) +
  scale_fill_colorblind()


# 図4.37（p.176） -----------------------------------------------------
## 左図
ggplot(data = mpg, mapping = aes(x = displ, y = cty, group = factor(cyl), colour = factor(cyl))) +
  geom_point()

## 右図
ggplot(data = mpg, mapping = aes(x = displ, y = cty, group = factor(cyl), colour = factor(cyl))) +
  geom_point() +
  labs(title = "エンジンの大きさと市街地における燃費の関係",
       subtitle = "1999年と2008年のデータを用いて",
       caption = "出典：xxx",
       x = "エンジンの大きさ（L）",
       y = "市街地における燃費（mpg）",
       colour = "シリンダー数")


# 図4.38（p.177） -----------------------------------------------------
install.packages("ggpubr")
library(ggpubr)

g1 <- ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  theme_classic() +
  geom_point(colour = "seagreen")

g2 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  theme_classic() +
  geom_point(colour = "lightskyblue")

ggarrange(g1, g2, labels = c("市街地", "高速道路"), ncol = 2, hjust = -1.5)


# 図4.39（p.178） -----------------------------------------------------
install.packages("patchwork")
library(patchwork)
g3 <- ggplot(data = mpg, aes(x = displ, y = drv)) +
  theme_classic() +
  geom_boxplot()

(g1 + g2) / g3


# 図4.40（p.179） -----------------------------------------------------
## サンプルデータの作成
weight_change <- data.frame(time = c("pre", "post_2days", "post_10days", "post_20days"),
                            weight = c(60, 60, 57, 55))

## 左図
ggplot(data = weight_change, mapping = aes(x = time, y = weight)) +
  geom_point() +
  geom_line(group = 1) +
  coord_cartesian(ylim = c(50, 65))

## 右図
weight_change$time <- fct_relevel(weight_change$time, "pre", "post_2days")

ggplot(data = weight_change, mapping = aes(x = time, y = weight)) +
  geom_point() +
  geom_line(group = 1) +
  coord_cartesian(ylim = c(50, 65))