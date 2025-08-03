# Helena Ven van Toen Website Backup

Automatische dagelijkse backup van https://www.helenaveenvantoen.nl

## Hoe het werkt

De GitHub Action draait dagelijks om 03:00 UTC en:
1. Downloadt de volledige website met **HTTrack** (veel beter voor complete website backups)
2. Slaat deze op in de `helenaveenvantoen.nl/` map
3. Commit alleen als er wijzigingen zijn

## Backup maken

### Optie 1: Lokaal HTTrack script
```bash
# Voer het HTTrack backup script uit
./backup-httrack.sh
```

### Optie 2: Met GitHub CLI 
```bash
# Handmatig de workflow starten
gh workflow run "Daily Website Backup"

# Status van workflow runs bekijken
gh run list --workflow="backup-site.yml"
```

### Optie 3: Met act (lokaal GitHub Actions simuleren)
```bash
# Installeer act
brew install act  # macOS
# of
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Voer workflow lokaal uit
act workflow_dispatch
```

## Repository setup

1. Push deze files naar je GitHub repository
2. De workflow start automatisch dagelijks om 03:00 UTC
3. Backups worden opgeslagen in de `helenaveenvantoen.nl/` map