# 使用 Playwright 官方最新穩定映像
FROM mcr.microsoft.com/playwright:v1.48.0-jammy

# 設定工作目錄
WORKDIR /app

# 先安裝 Python 3 和 pip（這是關鍵！）
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

# 建立 python 指令的符號連結（讓 python 和 pip 能直接用）
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# 複製並安裝 Python 套件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 安裝 Playwright 所需的瀏覽器（最穩方式）
RUN playwright install --with-deps chromium

# 複製程式碼
COPY . .

# 暴露端口
EXPOSE 5000

# 用 gunicorn 啟動（推薦）
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]
