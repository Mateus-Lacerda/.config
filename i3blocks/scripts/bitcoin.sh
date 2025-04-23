#!/bin/bash

# 1) Extrai os dados crus
data_price=$(curl -s 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true')
raw_price=$(echo "$data_price"   | jq -r '.bitcoin.usd')
raw_change=$(echo "$data_price"  | jq -r '.bitcoin.usd_24h_change')
raw_dom=$(curl -s 'https://api.coingecko.com/api/v3/global' \
               | jq -r '.data.market_cap_percentage.btc')

# 2) Preço
if [[ -z "$raw_price" || "$raw_price" == "null" ]]; then
  price_disp="-"
else
  price_disp="$raw_price"
fi

# 3) Dominância
if [[ -z "$raw_dom" || "$raw_dom" == "null" ]]; then
  dom_disp="-"
else
  dom_disp=$(printf "%.2f%%" "$raw_dom")
fi

# 4) Variação 24h
if [[ -z "$raw_change" || "$raw_change" == "null" ]]; then
  change_disp="-"
else
  sign=$(awk -v v="$raw_change" 'BEGIN{printf("%s", v>=0?"+":"-")}')
  abs_ch=$(awk -v v="$raw_change" 'BEGIN{printf("%.2f", (v<0?-v:v))}')
  change_disp="${sign}${abs_ch}%"
fi

# 5) Saída Pango com estilo
echo "<span foreground='#f7931a'></span><span background='#f7931a' foreground='#000000'>  ${price_disp} USD |  ${dom_disp} | 24h: ${change_disp} </span><span foreground='#282828' background='#f7931a'></span>"

