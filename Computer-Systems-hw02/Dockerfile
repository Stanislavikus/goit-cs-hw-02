# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Системні пакети для psycopg2 (libpq) та збірки
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

# Спочатку залежності (для кешу)
COPY requirements.txt .
# У деяких репозиторіях трапляється опечатка "uvicorn[standart]".
# Якщо збірка впаде, замініть у requirements на "uvicorn[standard]".
RUN pip install --no-cache-dir -r requirements.txt

# Далі — увесь код
COPY . .

# Порт застосунку
ENV PORT=8000

# Запуск uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
