# 使用 Playwright 最新官方映像（含 Chromium + 中文字型）
FROM mcr.microsoft.com/playwright:v1.48.0-jammy

# 設定工作目錄
WORKDIR /app

# 安裝中文字型（ddddocr 辨識中文驗證碼必備！）
RUN apt-get update && apt-get install -y \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

# 複製依賴檔並安裝
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 強制安裝 Playwright 的 Chromium（這行一定要有！）
RUN playwright install --with-deps chromium

# 複製專案所有檔案
COPY . .

# 暴露端口
EXPOSE 5000

# 使用 gunicorn 啟動（Render 推薦）
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]