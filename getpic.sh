#!/home/wocall/doctor/getpic/venv/bin/python
import os
import re
import time
import requests
from urllib.parse import urljoin, urlparse
from PIL import Image
from io import BytesIO
# ===== 用户输入 =====
URL = input("请输入网页URL: ").strip()
SAVE_DIR = input("请输入保存路径（默认 ./images）: ").strip() or "images"
MIN_WIDTH = input("请输入最小宽度（默认800）: ").strip()
MIN_WIDTH = int(MIN_WIDTH or 800)

if not os.path.exists(SAVE_DIR):
    os.makedirs(SAVE_DIR)
    print(f"📁 已创建目录: {SAVE_DIR}")

# ===== 直接请求页面 =====
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
    "Cookie": "ismob=0",
    "Referer": "https://ce.hf58yp.top/"
}
print("🌐 请求页面...")
r = requests.get(URL, headers=headers, timeout=30)
html = r.text
print(f"✅ 页面获取完成（{len(html)} 字节）")

# ===== 提取图片 =====
image_urls = set()

# 1. <img> 常规属性
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, "html.parser")
for img in soup.find_all("img"):
    for attr in ["src", "data-src", "data-original", "data-lazy-src"]:
        val = img.get(attr)
        if val:
            image_urls.add(urljoin(URL, val))
    ess = img.get("ess-data")
    if ess:
        matches = re.findall(r'\[img\](https?://[^\s\]]+)', ess)
        image_urls.update(matches)

# 2. 页面内 [img]xxx[/img]
matches = re.findall(r'\[img\](https?://[^\s\]]+)', html)
image_urls.update(matches)

# 3. CSS 背景图
matches = re.findall(r'background-image:\s*url\((https?://[^)]+)\)', html)
image_urls.update(matches)

# 4. 通用 jpg/png/webp
matches = re.findall(r'(https?://[^\s\'"]+\.(jpg|jpeg|png|webp))', html)
image_urls.update([m[0] for m in matches])

print(f"🎯 共解析到 {len(image_urls)} 张图片")

# ===== 下载 =====
def get_image_size(content):
    try:
        img = Image.open(BytesIO(content))
        return img.size
    except:
        return (0,0)

count = 0
for img_url in image_urls:
    try:
        r = requests.get(img_url, timeout=15)
        if r.status_code != 200:
            continue

        w, h = get_image_size(r.content)
        if w < MIN_WIDTH:
            continue

        filename = os.path.basename(urlparse(img_url).path)
        path = os.path.join(SAVE_DIR, filename)
        base, ext = os.path.splitext(path)
        i = 1
        while os.path.exists(path):
            path = f"{base}_{i}{ext}"
            i += 1

        with open(path, "wb") as f:
            f.write(r.content)

        count += 1
        print(f"✅ {path} ({w}x{h})")

    except Exception as e:
        print(f"⚠️ 跳过: {img_url} ({e})")

print(f"\n🎉 完成！共下载 {count} 张图片")
