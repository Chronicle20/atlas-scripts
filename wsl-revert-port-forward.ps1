# List of ports to forward
$ports = @(8080, 8081, 8082, 1200, 1202, 1203, 1204, 8300, 8302, 8303, 8304, 8700, 8702, 8703, 8704, 9200, 9202, 9203, 9204, 9500, 9502, 9503, 9504, 18500, 18502, 18503, 18504)

# Remove existing port proxies
foreach ($port in $ports) {
    Write-Host "🔄 Removing port fowarding $port..."

    # Remove existing rules (if they exist)
    netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=$port > $null 2>&1
    netsh interface portproxy delete v4tov4 listenaddress=$external_ip listenport=$port > $null 2>&1
}

# Display current rules
netsh interface portproxy show all