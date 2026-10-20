# Architecture Diagram — Azure Web App + SQL + Front Door

## Lucid diagram

- **View:** https://lucid.app/lucidchart/ea41419e-6a90-49e1-9013-2f61a9597784/view
- **Edit:** https://lucid.app/lucidchart/ea41419e-6a90-49e1-9013-2f61a9597784/edit

## Lucid prompt (reusable)

```
Create an Azure architecture diagram titled "Azure Web App + SQL + Front Door".
A Global User connects over HTTPS to Azure Front Door, which forwards to an App
Service (Linux) origin; the App Service connects to an Azure SQL Database over TDS
(port 1433). Label the arrows. Clean, professional Azure colors.
```

## Mermaid source

```mermaid
flowchart LR
    User([Global User])
    FD[Azure Front Door]
    App[App Service - Linux]
    SQL[(Azure SQL Database)]
    User -->|HTTPS| FD
    FD -->|origin| App
    App -->|TDS 1433| SQL
```
