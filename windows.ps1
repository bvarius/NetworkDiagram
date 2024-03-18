function Remove-Defaults {
    param(
        [Parameter(Mandatory=$true)]
        [string[]] $List1,
        [Parameter(Mandatory=$true)]
        [string[]] $DefaultList
    )

    $nonDefaults = $List1 | Where-Object { 
        -not ( $DefaultList -contains $_ ) 
    }
    return $nonDefaults
}

#Default Lists
$defaultServices = @("Base Filtering Engine", "Background Tasks Infrastructure Service", "COM+ System Application", "Cryptographic Services", "DCOM Server Process Launcher", "DHCP Client", "DNS Client", "Diagnostic Policy Service", "Windows Event Log", "COM+ Event System", "Windows Font Cache Service", "Group Policy Client", "IP Helper", "Server", "Workstation", "TCP/IP NetBIOS Helper", "Local Session Manager", "Windows Firewall", "Distributed Transaction Coordinator", "Network List Service", "Network Location Awareness", "Network Store Interface Service", "Plug and Play", "Power", "User Profile Service", "Remote Registry", "RPC Endpoint Mapper", "Remote Procedure Call (RPC)", "Security Accounts Manager", "Task Scheduler", "System Event Notification Service", "Shell Hardware Detection", "Print Spooler", "Themes", "Distributed Link Tracking Client", "User Access Logging Service", "VMTools", "WinHTTP Web Proxy Auto-Discovery Service", "Windows Management Instrumentation", "Windows Remote Management (WS-Management)", "Connected Devices Platform Service", "CDPUserSvc_b16db", "CoreMessaging", "Connected User Experiences and Telemetry", "CNG Key Isolation", "Geolocation Service", "Downloaded Maps Manager", "Network Connection Broker", "Sync Host_b16db", "Program Compatibility Assistant Service", "Software Protection", "SSDP Discovery", "State Repository Service", "System Events Broker", "Tile Data model server", "Time Broker", "User Manager", "Credential Manager", "VMware Alias Manager and Ticket Service", "VMware SVGA Helper Service", "VMware Tools", "Windows Time", "Windows Biometric Service", "Windows Connection Manager", "Windows Defender Network Inspection Service", "Windows Defender Service", "Microsoft Account Sign-in Assistant", "Windows Push Notifications System Service", "Windows Update", "Windows Driver Foundation - User-mode Driver Framework", "Application Management", "AppX Deployment Service (AppXSVC)", "Connected Devices Platform User Service_9b32a", "Client License Service (ClipSVC)", "Delivery Optimization", "Windows Defender Firewall", "Network Setup Service", "Windows Security Service", "Storage Service", "SysMain", "Touch Keyboard and Handwriting Panel Service", "Web Account Manager", "Update Orchestrator Service", "Windows Defender Antivirus Network Inspection Service", "Windows Defender Antivirus Service", "Windows Push Notifications User Service_9b32a", "Background Intelligent Transfer Service", "Capability Access Manager Service", "Clipboard User Service_4261b", "Connected Devices Platform User Service_4261b", "Display Policy Service", "Device Setup Manager", "Microsoft Edge Update Service (edgeupdate)", "Windows Modules Installer", "VMware Snapshot Provider", "Volume Shadow Copy", "Windows Update Medic Service", "Microsoft Defender Antivirus Network Inspection Service", "Microsoft Defender Antivirus Service", "WMI Performance Adapter", "Portable Device Enumerator Service", "Windows Push Notifications User Service_4261b")
#$defaultPrograms = @("temp")

#Get HostName
$hostname = $env:computername

#Get IP Address
$ip = (Get-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4).IPAddress

#Get OS Version
$osVersion = [environment]::OSVersion.VersionString

#Get Services
$services = (Get-Service | Where-Object {$_.StartType -eq 'Automatic' -or $_.Status -eq 'Running'} | Select-Object DisplayName).DisplayName

$goodServices = Remove-Defaults -List1 $services -DefaultList $defaultServices

#Get Installed Programs
$programs = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
#$goodPrograms = Remove-Defaults -List1 $programs -DefaultList $defaultPrograms

#Get Non-Default Program Files


#Write to output file
echo "Hostname" > sample.txt
$hostname >> sample.txt
echo "" >> sample.txt
echo "IP Address" >> sample.txt
$IP >> sample.txt
echo "" >> sample.txt
echo "OS Version" >> sample.txt
$OSVersion >> sample.txt
echo "" >> sample.txt
echo "Services" >> sample.txt
ForEach ($service in $goodServices) {
    if ($service) {
        "`t" + $service >> sample.txt
    }
}
echo "" >> sample.txt
echo "Programs" >> sample.txt
ForEach ($program in $programs) {
    if ($program.DisplayName) {
        #Remove Version Number if in DisplayName, then include version number
        #(Removes double version number)
        "`t" + ($program.DisplayName -replace "\s?(\d)*(\.\d+)+\s?", "") + ' '+ $program.DisplayVersion >> sample.txt
    }
}