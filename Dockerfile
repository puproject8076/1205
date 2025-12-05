# 使用 Playwright 官方最新映像
FROM mcr.microsoft.com/playwright:v1.48.0-jammy

# 設定工作目錄
WORKDIR /app

# 安裝 Python3 + pip + 中文字型（一次搞定）
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python || true \     # 強制覆蓋或忽略錯誤
    # ln -sf：如果檔案已存在會強制覆蓋，|| true：就算失敗也繼續

# 確保 pip 是最新版（避免後面警告）
RUN python -m pip install --upgrade pip

# 複製並安裝所有 Python 套件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 安裝 Chromium（Playwright 必要）
RUN playwright install --with-deps chromium

# 複製程式碼
COPY . .

EXPOSE 5000

# 啟動方式（gunicorn 穩定度最高）
CMD ["gunicorn", "-w", "1", "--timeout", "180", "--max-requests", "10", "--max-requests-jitter", "5", "-b", "0.0.0.0:5000", "app:app"]

