# Splunk + MITRE ATT&CK Detection Lab

This lab forwards Windows event logs to Splunk, maps them to MITRE ATT&CK techniques, and visualizes them in a real-time dashboard. Built to simulate detection engineering workflows using Splunk, Sysmon (optional), and the MITRE framework.

See mitre_lookup/mitre_lookup.csv and dashboards/ for dashboard XML.

## Structure
- configs/ → Splunk Universal Forwarder config files (e.g., inputs.conf)
- mitre_lookup/ → CSV mapping of EventCodes to MITRE TTPs
- dashboards/ → Splunk dashboard XML
- examples/screenshots/ → Visuals for README/LinkedIn posts
