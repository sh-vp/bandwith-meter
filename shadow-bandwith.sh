#!/bin/bash

while getopts "i:" arg; do
  case $arg in
    i) interface=$OPTARG;;
  esac
done
rx_bytes=$(cat "/sys/class/net/${interface}/statistics/rx_bytes")
tx_bytes=$(cat "/sys/class/net/${interface}/statistics/tx_bytes")

rx_mb=$((rx_bytes / 1048576))
tx_mb=$((tx_bytes / 1048576))
total_mb=$(((tx_bytes + rx_bytes)/ 1048576))
if ((rx_mb < 1024)); then
    rx_unit="MB"
    rx_value=$rx_mb
elif ((rx_mb > 1024 && rx_mb <= 1024*1024)); then
    rx_unit="GB"
    rx_value=$(printf "%.2f" "$(bc -l <<< "$rx_mb / 1024")")
elif ((rx_mb >= (1024 * 1024))); then
    rx_unit="TB"
    rx_value=$(printf "%.2f" "$(bc -l <<< "$rx_mb / (1024 * 1024)")")

fi
if ((tx_mb < 1024)); then
    tx_unit="MB"
    tx_value=$tx_mb
elif ((tx_mb > 1024 && tx_mb <= 1024*1024)); then
    tx_unit="GB"
    tx_value=$(printf "%.2f" "$(bc -l <<< "$tx_mb / 1024")")
elif ((tx_mb >= (1024 * 1024))); then
    tx_unit="TB"
    tx_value=$(printf "%.2f" "$(bc -l <<< "$tx_mb / (1024 * 1024)")")

fi
if ((total_mb < 1024)); then
    total_unit="MB"
    total_value=$total_mb
elif ((total_mb > 1024 && total_mb <= 1024*1024)); then
    total_unit="GB"
    total_value=$(printf "%.2f" "$(bc -l <<< "$total_mb / 1024")")
elif ((total_mb >= (1024 * 1024))); then
    total_unit="TB"
    total_value=$(printf "%.2f" "$(bc -l <<< "$total_mb / (1024 * 1024)")")

fi

echo ""
echo "  ===================="
echo "  Interface ${interface}:"
echo "     RX: ${rx_value} ${rx_unit}"
echo "     TX: ${tx_value} ${tx_unit}"
echo "  Total: ${total_value} ${total_unit}"
echo "  ===================="
echo ""

