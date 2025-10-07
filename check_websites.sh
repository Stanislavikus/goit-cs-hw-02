# website_check.sh — перевірка доступності вебсайтів через curl (HTTP GET)

# Список сайтів для перевірки
SITES=(
  "https://google.com"
  "https://facebook.com"
  "https://twitter.com"
)

# Назва файлу логів
LOG_FILE="website_status.log"

# User-Agent (допомагає уникнути хибних 403/406 на деяких сайтах)
USER_AGENT="Mozilla/5.0 (compatible; website-checker/1.0; +https://example.local)"

# Налаштування: не зупиняємось на помилках curl, але ловимо поламані пайпи
set -u -o pipefail

timestamp="$(date +"%Y-%m-%d %H:%M:%S %Z")"

{
  echo "=== Website availability check — ${timestamp} ==="
  for url in "${SITES[@]}"; do
    # Додамо '/' для Markdown-посилання в логах, якщо його немає
    if [[ "${url: -1}" == "/" ]]; then
      url_slash="$url"
    else
      url_slash="$url/"
    fi

    # Відправляємо HTTP GET, слідуємо редіректам (-L), тихо (-s), без тіла (-o /dev/null),
    # пишемо лише код статусу (-w), з тайм-аутами
    http_code="$(
      curl -X GET -L -s -o /dev/null -w "%{http_code}" \
        --max-time 15 --connect-timeout 10 \
        -A "$USER_AGENT" \
        "$url"
    )"

    if [[ "$http_code" == "200" ]]; then
      echo "[<$url>](<$url_slash>) is UP"
    else
      echo "[<$url>](<$url_slash>) is DOWN (HTTP $http_code)"
    fi
  done
  echo
} >> "$LOG_FILE"

echo "Результати записано у файл логів: $LOG_FILE"
