# Splunk + MITRE ATT&CK Detection Lab

This lab forwards Windows event logs to Splunk, maps them to MITRE ATT&CK techniques, and visualizes them in a real-time dashboard. Built to simulate detection engineering workflows using Splunk, Sysmon (optional), and the MITRE framework.

See mitre_lookup/mitre_lookup.csv and dashboards/ for dashboard XML.

## Structure
- configs/ → Splunk Universal Forwarder config files (e.g., inputs.conf)
- mitre_lookup/ → CSV mapping of EventCodes to MITRE TTPs
- dashboards/ → Splunk dashboard XML
- examples/screenshots/ → Visuals for README/LinkedIn posts

## How to Replicate This Lab

This project sets up a local Splunk detection lab that forwards Windows event logs to a Splunk Enterprise instance, maps EventCodes to MITRE ATT&CK techniques using a custom lookup, and visualizes them through a custom dashboard.

This lab is intended to be run on a local Windows machine using Splunk Enterprise and the Splunk Universal Forwarder.

---

### 1. Install Splunk Enterprise (Local)

Download and install Splunk Enterprise:

https://www.splunk.com/en_us/download/splunk-enterprise.html

- Choose the free license for personal use
- Confirm that it's accessible at: `http://localhost:8000`

---

### 2. Install Splunk Universal Forwarder

Download and install the Universal Forwarder for Windows:

https://www.splunk.com/en_us/download/universal-forwarder.html

During setup:
- Set the deployment receiver to `localhost:9997` (or your Splunk server's IP)
- Accept default management port (8089)
- Optionally add Splunk to the system PATH

---

### 3. Clone This Repository

```powershell
git clone https://github.com/YOUR_USERNAME/splunk-mitre-detection-lab.git
cd splunk-mitre-detection-lab
```

---

### 4. Run the Setup Script (Optional)

This repository includes a PowerShell script that automates most of the setup process, including copying configs and creating the correct project structure.

```powershell
.\setup.ps1
```

If script execution is disabled, enable it temporarily for your session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

### 5. Manually Apply Log Forwarding (If Not Using the Script)

Copy the included `inputs.conf` file to your Splunk Universal Forwarder configuration path:

```powershell
copy .\configs\inputs.conf "C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf"
```

Then restart the forwarder:

```powershell
cd "C:\Program Files\SplunkUniversalForwarder\bin"
.\splunk.exe restart
```

---

### 6. Upload the MITRE Lookup to Splunk

In Splunk Web:

1. Go to `Settings → Lookups → Lookup table files → Add new`
2. Upload `mitre_lookup\mitre_lookup.csv`
3. Then go to `Settings → Lookups → Lookup Definitions → Add new`
   - Lookup name: `mitre_lookup`
   - Choose the file you uploaded
   - Input field: `signature`
   - Output fields: `technique_id`, `technique_name`, `tactic`

---

### 7. Import the Dashboard

1. In Splunk Web: `Dashboards → Create New → Classic Dashboard`
2. Click the gear icon and select `Source`
3. Paste the contents of `dashboards/mitre_dashboard.xml`
4. Save and view the dashboard

---

### 8. (Optional) Simulate Test Events

To simulate basic activity for testing detection logic:

```powershell
New-EventLog -LogName Application -Source "HTBTestApp"
Write-EventLog -LogName Application -Source "HTBTestApp" -EventId 1001 -EntryType Information -Message "Simulated TTP Event"
```

You can also log on and off the system or restart services to generate additional events.

---

### 9. Expand with Adversary Simulation Tools

For deeper detection coverage and enrichment, consider adding:

- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team) – for TTP simulation
- [Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) – for process-level telemetry

---
