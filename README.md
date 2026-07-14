# get1024pic

网页图片批量下载工具，尤其是对 1024 做了适配。输入网页 URL，自动解析页面中的所有图片并下载到本地。

## 功能特性

- 支持多种图片来源：`<img>` 标签（含 `data-src`、`data-original`、`data-lazy-src` 等懒加载属性）、CSS `background-image`、`[img]`BBCode 标签
- 支持按最小宽度过滤（默认 800px）
- 自动处理重名文件（添加 `_1`、`_2` 后缀）
- 支持 jpg / jpeg / png / webp 格式

## 环境要求

- Python 3.6+

## 安装

```bash
pip install -r requirements.txt
```

## 使用

```bash
python getpic.sh
```

或直接执行（需赋予执行权限）：

```bash
chmod +x getpic.sh
./getpic.sh
```

运行后根据提示依次输入：

1. **网页 URL** — 要爬取图片的页面地址
2. **保存路径** — 下载目录（直接回车使用默认 `./images`）
3. **最小宽度** — 只下载宽度不低于该值的图片（直接回车使用默认 `800`）

示例：

```
请输入网页URL: https://example.com/gallery
请输入保存路径（默认 ./images）:
请输入最小宽度（默认800）:
```

## 目录结构

```
get1024pic/
├── getpic.sh          # 主脚本
├── requirements.txt   # Python 依赖
├── images/            # 下载的图片（自动创建）
└── README.md          # 本文件
```

## 许可

MIT
