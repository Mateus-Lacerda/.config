#!/bin/bash

# Cache file to reduce API calls
CACHE_FILE="/tmp/bitcoin_cache.json"
CACHE_DURATION=60  # Cache for 60 seconds

# Check if cache exists and is recent
if [[ -f "$CACHE_FILE" && $(find "$CACHE_FILE" -mmin -1) ]]; then
    data_price=$(cat "$CACHE_FILE")
else
    data_price=$(curl -s 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true')
    echo "$data_price" > "$CACHE_FILE"
fi

# Extract raw data
raw_price=$(echo "$data_price" | jq -r '.bitcoin.usd')
raw_change=$(echo "$data_price" | jq -r '.bitcoin.usd_24h_change')
raw_dom=$(curl -s 'https://api.coingecko.com/api/v3/global' | jq -r '.data.market_cap_percentage.btc')

# Price
if [[ -z "$raw_price" || "$raw_price" == "null" ]]; then
    price_disp="-"
else
    price_disp="$raw_price USD"
fi

# Dominance
if [[ -z "$raw_dom" || "$raw_dom" == "null" ]]; then
    dom_disp="-"
else
    dom_disp=$(printf "%.2f%%" "$raw_dom")
fi

# 24h Change
if [[ -z "$raw_change" || "$raw_change" == "null" ]]; then
    change_disp="-"
else
    sign=$(awk -v v="$raw_change" 'BEGIN{printf("%s", v>=0?"+":"-")}')
    abs_ch=$(awk -v v="$raw_change" 'BEGIN{printf("%.2f", (v<0?-v:v))}')
    change_disp="${sign}${abs_ch}%"
fi

# Pango output with Nerd Font icons
echo "  ${price_disp}   ${dom_disp}  󱑸 ${change_disp} "
