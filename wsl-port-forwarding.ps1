# List of ports to forward
$ports = @(8080, 8081, 8082, 1200, 1202, 1203, 1204, 8300, 8302, 8303, 8304, 8700, 8702, 8703, 8704, 9200, 9202, 9203, 9204, 9500, 9502, 9503, 9504, 18500, 18502, 18503, 18504)

# Get the current WSL2 IP address
$wsl_ip = (wsl hostname -I).Trim()

# Get the external IP of this machine (on the local network)
$ethernet_interface = "Ethernet"  # Change this if your interface has a different name
$external_ip = (Get-NetIPAddress -AddressFamily IPv4 |
                Where-Object { $_.InterfaceAlias -eq $ethernet_interface }).IPAddress

# Check if WSL IP was retrieved
if (-not $wsl_ip) {
    Write-Host "❌ Failed to retrieve WSL2 IP. Ensure WSL is running." -ForegroundColor Red
    exit 1
}

# Check if external IP was retrieved
if (-not $external_ip) {
    Write-Host "❌ Failed to retrieve external IP. Ensure you are connected to a network." -ForegroundColor Red
    exit 1
}

# Remove existing port proxies
foreach ($port in $ports) {
    Write-Host "🔄 Forwarding port $port to WSL ($wsl_ip) on localhost and ($external_ip) on external network..."

    # Remove existing rules (if they exist)
    netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=$port > $null 2>&1
    netsh interface portproxy delete v4tov4 listenaddress=$external_ip listenport=$port > $null 2>&1

    # Forward localhost to WSL
    netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=$port connectaddress=$wsl_ip connectport=$port

    # Forward external IP to WSL
    netsh interface portproxy add v4tov4 listenaddress=$external_ip listenport=$port connectaddress=$wsl_ip connectport=$port
	
	New-NetFirewallRule `
        -DisplayName "Allow Port $port for External Access" `
        -Direction Inbound `
        -Protocol TCP `
        -LocalPort $port `
        -Action Allow `
        -Profile Any
}

# Display current rules
netsh interface portproxy show all